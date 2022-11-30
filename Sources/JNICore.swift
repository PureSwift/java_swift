//
//  JavaJNI.swift
//  SwiftJava
//
//  Created by John Holdsworth on 13/07/2016.
//  Copyright (c) 2016 John Holdsworth. All rights reserved.
//
//  Basic JNI functionality notably initialising a JVM on Unix
//  as well as maintaining cache of currently attached JNI.env
//

import Foundation
import Dispatch
#if canImport(Glibc)
import Glibc
#endif
@_exported import CJavaVM

@_silgen_name("JNI_OnLoad")
public func JNI_OnLoad( jvm: UnsafeMutablePointer<JavaVM?>, ptr: UnsafeRawPointer ) -> jint {
    JNI.jvm = jvm
    let env: UnsafeMutablePointer<JNIEnv?>? = JNI.GetEnv()
    JNI.api = env!.pointee!.pointee

    var result = withUnsafeMutablePointer(to: &jniEnvKey, {
        pthread_key_create($0, JNI_DetachCurrentThread)
    })
    if (result != 0) {
        fatalError("Can't pthread_key_create")
    }
    pthread_setspecific(jniEnvKey, env)

    result = withUnsafeMutablePointer(to: &jniFatalMessage, {
        pthread_key_create($0, JNI_RemoveFatalMessage)
    })
    if (result != 0) {
        fatalError("Can't pthread_key_create")
    }
    
    // Save ContextClassLoader for FindClass usage
    // When a thread is attached to the VM, the context class loader is the bootstrap loader.
    // https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/invocation.html
    // https://developer.android.com/training/articles/perf-jni.html#faq_FindClass
    JNI.classLoader = JavaThread.currentThread().getContextClassLoader().withJavaObject { JNI.api.NewGlobalRef( env, $0 ) }

    return jint(JNI_VERSION_1_6)
}

fileprivate class FatalErrorMessage {
    let description: String
    let file: String
    let line: Int

    init(description: String, file: String, line: Int) {
        self.description = description
        self.file = file
        self.line = line
    }
}

public func JNI_DetachCurrentThread(_ ptr: UnsafeMutableRawPointer?) {
    _ = JNI.jvm?.pointee?.pointee.DetachCurrentThread( JNI.jvm )
}

public func JNI_RemoveFatalMessage(_ ptr: UnsafeMutableRawPointer?) {
    if let ptr = ptr {
        Unmanaged<FatalErrorMessage>.fromOpaque(ptr).release()
    }
}

public let JNI = JNICore()
fileprivate var jniEnvKey = pthread_key_t()
fileprivate var jniFatalMessage = pthread_key_t()

open class JNICore {

    open var jvm: UnsafeMutablePointer<JavaVM?>?
    open var api: JNINativeInterface_!
    open var classLoader: jobject?

    open var threadKey: pid_t { return gettid() }

    open var errorLogger: (_ message: String) -> Void = { message in
        NSLog(message)
    }

    open var env: UnsafeMutablePointer<JNIEnv?>? {
        if let env: UnsafeMutableRawPointer = pthread_getspecific(jniEnvKey) {
            return env.assumingMemoryBound(to: JNIEnv?.self)
        }
        let env = AttachCurrentThread()
        let error = pthread_setspecific(jniEnvKey, env)
        if error != 0 {
            NSLog("Can't save env to pthread_setspecific")
        }
        return env
    }

    open func AttachCurrentThread() -> UnsafeMutablePointer<JNIEnv?>? {
        var tenv: UnsafeMutablePointer<JNIEnv?>?
        if withPointerToRawPointer(to: &tenv, {
            self.jvm?.pointee?.pointee.AttachCurrentThread( self.jvm, $0, nil )
        } ) != jint(JNI_OK) {
            report( "Could not attach to background jvm" )
        }
        return tenv
    }

    open func report( _ msg: String, _ file: StaticString = #file, _ line: Int = #line ) {
        errorLogger( "\(msg) - at \(file):\(line)" )
        if let throwable: jthrowable = ExceptionCheck() {
            let throwable = Throwable(javaObject: throwable)
            let className = throwable.className()
            let message = throwable.getMessage()
            let stackTrace = throwable.stackTraceString()
            errorLogger("\(className): \(message ?? "unavailable")\(stackTrace)")
            throwable.printStackTrace()
        }
    }

    open func initJVM( options: [String]? = nil, _ file: StaticString = #file, _ line: Int = #line ) -> Bool {
#if os(Android)
        return true
#else
        if jvm != nil {
            report( "JVM can only be initialised once", file, line )
            return true
        }

        var options: [String]? = options
        if options == nil {
            var classpath: String = String( cString: getenv("HOME") )+"/.swiftjava.jar"
            if let CLASSPATH: UnsafeMutablePointer<Int8> = getenv( "CLASSPATH" ) {
                classpath += ":"+String( cString: CLASSPATH )
            }
            options = ["-Djava.class.path="+classpath,
                       // add to bootclasspath as threads not started using Thread class
                       // will not have the correct classloader and be missing classpath
                       "-Xbootclasspath/a:"+classpath]
        }

        var vmOptions = [JavaVMOption]( repeating: JavaVMOption(), count: options?.count ?? 1 )

        return vmOptions.withUnsafeMutableBufferPointer {
            (vmOptionsPtr) in
            var vmArgs = JavaVMInitArgs()
            vmArgs.version = jint(JNI_VERSION_1_6)
            vmArgs.nOptions = jint(options?.count ?? 0)
            vmArgs.options = vmOptionsPtr.baseAddress

            if let options: [String] = options {
                for i in 0..<vmOptionsPtr.count {
                    options[i].withCString {
                        (cString) in
                        vmOptionsPtr[i].optionString = strdup( cString )
                    }
                }
            }

            var tenv: UnsafeMutablePointer<JNIEnv?>?
            if withPointerToRawPointer(to: &tenv, {
                JNI_CreateJavaVM( &self.jvm, $0, &vmArgs )
            } ) != jint(JNI_OK) {
                report( "JNI_CreateJavaVM failed", file, line )
                return false
            }

            if pthread_setspecific( JNICore.envVarKey, tenv ) != 0 {
                JNI.report( "Could not set pthread specific tenv" )
            }
            self.api = self.env!.pointee!.pointee
            return true
        }
#endif
    }

    private func withPointerToRawPointer<T, Result>(to arg: inout T, _ body: @escaping (UnsafeMutablePointer<UnsafeMutableRawPointer?>) throws -> Result) rethrows -> Result {
        return try withUnsafeMutablePointer(to: &arg) {
            try $0.withMemoryRebound(to: UnsafeMutableRawPointer?.self, capacity: 1) {
                try body( $0 )
            }
        }
    }

    open func GetEnv() -> UnsafeMutablePointer<JNIEnv?>? {
        var tenv: UnsafeMutablePointer<JNIEnv?>?
        if withPointerToRawPointer(to: &tenv, {
            JNI.jvm?.pointee?.pointee.GetEnv( JNI.jvm, $0, jint(JNI_VERSION_1_6 ) )
        } ) != jint(JNI_OK) {
            report( "Unable to get initial JNIEnv" )
        }
        return tenv
    }

    fileprivate let initLock = NSLock()

    private func autoInit() {
        initLock.lock()
        if jvm == nil && !initJVM() {
            report( "Auto JVM init failed" )
        }
        initLock.unlock()
    }

    open func background( closure: @escaping () -> () ) {
        autoInit()
        DispatchQueue.global(qos: .default).async {
            closure()
        }
    }

    public func run() {
        RunLoop.main.run(until: Date.distantFuture)
    }
    
    private var loadClassMethodID: jmethodID?

    open func FindClass( _ name: UnsafePointer<Int8>, _ file: StaticString = #file, _ line: Int = #line ) -> jclass? {
        autoInit()
        ExceptionReset()
        var clazz: jclass?

        if classLoader == nil {
            clazz = api.FindClass( env, name )
        }
        else {
            var locals = [jobject]()
            var args = [jvalue(l: String(cString: name).localJavaObject(&locals))]
            clazz = JNIMethod.CallObjectMethod(object: classLoader,
                                               methodName: "loadClass",
                                               methodSig: "(Ljava/lang/String;)Ljava/lang/Class;",
                                               methodCache: &loadClassMethodID,
                                               args: &args,
                                               locals: &locals)
        }

        if clazz == nil {
            report( "Could not find class \(String( cString: name ))", file, line )
            if strncmp( name, "org/swiftjava/", 14 ) == 0 {
                report( "\n\nLooking for a swiftjava proxy class required for event listeners and Runnable's to work.\n" +
                    "Have you copied https://github.com/SwiftJava/SwiftJava/blob/master/swiftjava.jar to ~/.swiftjava.jar " +
                    "and/or set the CLASSPATH environment variable?\n" )
            }
        }
        return clazz
    }

    open func CachedFindClass( _ name: UnsafePointer<Int8>, _ classCache: UnsafeMutablePointer<jclass?>,
                               _ file: StaticString = #file, _ line: Int = #line ) {
        if classCache.pointee == nil, let clazz: jclass = FindClass( name, file, line ) {
            classCache.pointee = api.NewGlobalRef( env, clazz )
            api.DeleteLocalRef( env, clazz )
        }
    }

    open func GetObjectClass( _ object: jobject?, _ locals: UnsafeMutablePointer<[jobject]>,
                              _ file: StaticString = #file, _ line: Int = #line ) -> jclass? {
        ExceptionReset()
        if object == nil {
            report( "GetObjectClass with nil object", file, line )
        }
        let clazz: jclass? = api.GetObjectClass( env, object )
        if clazz == nil {
            report( "GetObjectClass returns nil class", file, line )
        }
        else {
            locals.pointee.append( clazz! )
        }
        return clazz
    }

    private static var java_lang_ObjectClass: jclass?

    open func NewObjectArray( _ count: Int, _ array: [jobject?]?, _ locals: UnsafeMutablePointer<[jobject]>, _ file: StaticString = #file, _ line: Int = #line  ) -> jobjectArray? {
        CachedFindClass( "java/lang/Object", &JNICore.java_lang_ObjectClass, file, line )
        var arrayClass: jclass? = JNICore.java_lang_ObjectClass
        if array?.count != 0 {
            arrayClass = JNI.GetObjectClass( array![0], locals )
        }
        else {
#if os(Android)
            return nil
#endif
        }
        let array: jobjectArray? = api.NewObjectArray( env, jsize(count), arrayClass, nil )
        if array == nil {
            report( "Could not create array", file, line )
        }
        return array
    }

    open func DeleteLocalRef( _ local: jobject? ) {
        if local != nil {
            api.DeleteLocalRef( env, local )
        }
    }

    private var thrownCache = [pid_t: jthrowable]()
    private let thrownLock = NSLock()

    open func check<T>( _ result: T, _ locals: UnsafeMutablePointer<[jobject]>, removeLast: Bool = false, _ file: StaticString = #file, _ line: Int = #line ) -> T {
        if removeLast && locals.pointee.count != 0 {
            locals.pointee.removeLast()
        }
        for local in locals.pointee {
            DeleteLocalRef( local )
        }
        if api.ExceptionCheck( env ) != 0 {
            if let throwable: jthrowable = api.ExceptionOccurred( env ) {
                thrownLock.lock()
                thrownCache[threadKey] = throwable
                thrownLock.unlock()
                api.ExceptionClear(env)
            }
        }
        return result
    }

    open func ExceptionCheck() -> jthrowable? {
        let currentThread: pid_t = threadKey
        if let throwable: jthrowable = thrownCache[currentThread] {
            thrownLock.lock()
            thrownCache.removeValue(forKey: currentThread)
            thrownLock.unlock()
            return throwable
        }
        return nil
    }

    open func ExceptionReset() {
        if let throwable: jthrowable = ExceptionCheck() {
            errorLogger( "Left over exception" )
            let throwable = Throwable(javaObject: throwable)
            let className = throwable.className()
            let message = throwable.getMessage()
            let stackTrace = throwable.stackTraceString()
            errorLogger("\(className): \(message ?? "unavailable")\(stackTrace)")
            throwable.printStackTrace()
        }
    }

    open func SaveFatalErrorMessage(_ msg: String, _ file: StaticString = #file, _ line: Int = #line) {
        let fatalError = FatalErrorMessage(description: msg, file: file.description, line: line)
        let ptr = Unmanaged.passRetained(fatalError).toOpaque()
        let error = pthread_setspecific(jniFatalMessage, ptr)
        if error != 0 {
            errorLogger("Can't save fatal message to pthread_setspecific")
        }
    }

    open func RemoveFatalErrorMessage() {
        pthread_setspecific(jniFatalMessage, nil)
    }

    open func GetFatalErrorMessage() -> String? {
        guard let ptr: UnsafeMutableRawPointer = pthread_getspecific(jniFatalMessage) else {
            return nil
        }
        let fatalErrorMessage = Unmanaged<FatalErrorMessage>.fromOpaque(ptr).takeUnretainedValue()
        return "\(fatalErrorMessage.description) at \(fatalErrorMessage.file):\(fatalErrorMessage.line)"
    }

}

extension JavaClass {
    public convenience init(loading className: String) {
        let clazz = JNI.FindClass( className.replacingOccurrences(of: ".", with: "/") )
        self.init( javaObject: clazz )
        JNI.DeleteLocalRef( clazz )
    }
}
