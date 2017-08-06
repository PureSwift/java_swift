
/// generated by: genswift.java 'java/lang|java/util|java/sql|java/awt|javax/swing' ///

/// JAVA_HOME: /Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home ///
/// Sat Aug 05 08:41:53 BST 2017 ///

/// interface java.util.Set ///

public protocol JavaSet: /* java.util.Collection */ UnclassedProtocol {

    /// public abstract boolean java.util.Set.add(java.lang.Object)

    func add( e: JavaObject? ) -> Bool

    /// public abstract boolean java.util.Set.remove(java.lang.Object)

    func remove( o: JavaObject? ) -> Bool

    /// public abstract boolean java.util.Set.equals(java.lang.Object)

    func equals( o: JavaObject? ) -> Bool

    /// public abstract int java.util.Set.hashCode()

    func hashCode() -> Int

    /// public abstract void java.util.Set.clear()

    /// public abstract boolean java.util.Set.isEmpty()

    func isEmpty() -> Bool

    /// public abstract boolean java.util.Set.contains(java.lang.Object)

    func contains( o: JavaObject? ) -> Bool

    /// public abstract int java.util.Set.size()

    func size() -> Int

    /// public abstract java.lang.Object[] java.util.Set.toArray(java.lang.Object[])

    func toArray( a: [JavaObject]? ) -> [JavaObject]!

    /// public abstract java.lang.Object[] java.util.Set.toArray()

    func toArray() -> [JavaObject]!

    /// public abstract java.util.Iterator java.util.Set.iterator()

    /// public default java.util.Spliterator java.util.Set.spliterator()

    /// public abstract boolean java.util.Set.addAll(java.util.Collection)

    func addAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool

    /// public abstract boolean java.util.Set.containsAll(java.util.Collection)

    func containsAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool

    /// public abstract boolean java.util.Set.removeAll(java.util.Collection)

    func removeAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool

    /// public abstract boolean java.util.Set.retainAll(java.util.Collection)

    func retainAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool

}


open class JavaSetForward: /* java.util.Collection */ UnclassedProtocolForward, JavaSet {

    private static var JavaSetJNIClass: jclass?

    /// public abstract boolean java.util.Set.add(java.lang.Object)

    private static var add_MethodID_14: jmethodID?

    open func add( e: JavaObject? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: e != nil ? e! as JNIObject : nil, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "add", methodSig: "(Ljava/lang/Object;)Z", methodCache: &JavaSetForward.add_MethodID_14, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.remove(java.lang.Object)

    private static var remove_MethodID_15: jmethodID?

    open func remove( o: JavaObject? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: o != nil ? o! as JNIObject : nil, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "remove", methodSig: "(Ljava/lang/Object;)Z", methodCache: &JavaSetForward.remove_MethodID_15, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.equals(java.lang.Object)

    private static var equals_MethodID_16: jmethodID?

    open func equals( o: JavaObject? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: o != nil ? o! as JNIObject : nil, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "equals", methodSig: "(Ljava/lang/Object;)Z", methodCache: &JavaSetForward.equals_MethodID_16, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract int java.util.Set.hashCode()

    private static var hashCode_MethodID_17: jmethodID?

    open func hashCode() -> Int {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        let __return = JNIMethod.CallIntMethod( object: javaObject, methodName: "hashCode", methodSig: "()I", methodCache: &JavaSetForward.hashCode_MethodID_17, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Int(), from: __return )
    }


    /// public abstract void java.util.Set.clear()

    /// public abstract boolean java.util.Set.isEmpty()

    private static var isEmpty_MethodID_18: jmethodID?

    open func isEmpty() -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "isEmpty", methodSig: "()Z", methodCache: &JavaSetForward.isEmpty_MethodID_18, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.contains(java.lang.Object)

    private static var contains_MethodID_19: jmethodID?

    open func contains( o: JavaObject? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: o != nil ? o! as JNIObject : nil, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "contains", methodSig: "(Ljava/lang/Object;)Z", methodCache: &JavaSetForward.contains_MethodID_19, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract int java.util.Set.size()

    private static var size_MethodID_20: jmethodID?

    open func size() -> Int {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        let __return = JNIMethod.CallIntMethod( object: javaObject, methodName: "size", methodSig: "()I", methodCache: &JavaSetForward.size_MethodID_20, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Int(), from: __return )
    }


    /// public abstract java.lang.Object[] java.util.Set.toArray(java.lang.Object[])

    private static var toArray_MethodID_21: jmethodID?

    open func toArray( a: [JavaObject]? ) -> [JavaObject]! {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: a, locals: &__locals )
        let __return = JNIMethod.CallObjectMethod( object: javaObject, methodName: "toArray", methodSig: "([Ljava/lang/Object;)[Ljava/lang/Object;", methodCache: &JavaSetForward.toArray_MethodID_21, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: [JavaObject](), from: __return )
    }

    open func toArray( _ _a: [JavaObject]? ) -> [JavaObject]! {
        return toArray( a: _a )
    }

    /// public abstract java.lang.Object[] java.util.Set.toArray()

    private static var toArray_MethodID_22: jmethodID?

    open func toArray() -> [JavaObject]! {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        let __return = JNIMethod.CallObjectMethod( object: javaObject, methodName: "toArray", methodSig: "()[Ljava/lang/Object;", methodCache: &JavaSetForward.toArray_MethodID_22, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: [JavaObject](), from: __return )
    }


    /// public abstract java.util.Iterator java.util.Set.iterator()

    /// public default java.util.Spliterator java.util.Set.spliterator()

    /// public abstract boolean java.util.Set.addAll(java.util.Collection)

    private static var addAll_MethodID_23: jmethodID?

    open func addAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: c, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "addAll", methodSig: "(Ljava/util/Collection;)Z", methodCache: &JavaSetForward.addAll_MethodID_23, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.containsAll(java.util.Collection)

    private static var containsAll_MethodID_24: jmethodID?

    open func containsAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: c, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "containsAll", methodSig: "(Ljava/util/Collection;)Z", methodCache: &JavaSetForward.containsAll_MethodID_24, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.removeAll(java.util.Collection)

    private static var removeAll_MethodID_25: jmethodID?

    open func removeAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: c, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "removeAll", methodSig: "(Ljava/util/Collection;)Z", methodCache: &JavaSetForward.removeAll_MethodID_25, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public abstract boolean java.util.Set.retainAll(java.util.Collection)

    private static var retainAll_MethodID_26: jmethodID?

    open func retainAll( c: /* java.util.Collection */ UnclassedProtocol? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: c, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "retainAll", methodSig: "(Ljava/util/Collection;)Z", methodCache: &JavaSetForward.retainAll_MethodID_26, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public default java.util.stream.Stream java.util.Collection.stream()

    /// public default boolean java.util.Collection.removeIf(java.util.function.Predicate)

    private static var removeIf_MethodID_27: jmethodID?

    open func removeIf( filter: /* java.util.function.Predicate */ UnclassedProtocol? ) -> Bool {
        var __args = [jvalue]( repeating: jvalue(), count: 1 )
        var __locals = [jobject]()
        __args[0] = JNIType.toJava( value: filter, locals: &__locals )
        let __return = JNIMethod.CallBooleanMethod( object: javaObject, methodName: "removeIf", methodSig: "(Ljava/util/function/Predicate;)Z", methodCache: &JavaSetForward.removeIf_MethodID_27, args: &__args, locals: &__locals )
        return JNIType.toSwift( type: Bool(), from: __return )
    }


    /// public default java.util.stream.Stream java.util.Collection.parallelStream()

    /// public default void java.lang.Iterable.forEach(java.util.function.Consumer)

    /// In declared protocol but not defined.. ///

    /// public default void java.lang.Iterable.forEach(java.util.function.Consumer)

    /// public abstract java.util.Iterator java.lang.Iterable.iterator()

    /// public default java.util.Spliterator java.lang.Iterable.spliterator()

    /// public default java.util.stream.Stream java.util.Collection.parallelStream()

    /// public default java.util.stream.Stream java.util.Collection.stream()

    /// public abstract void java.util.Collection.clear()

}

