//
//  CoreDataExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import CoreData

public extension NSManagedObjectContext {
    override var description: String {
        if let name = self.name {
            return "<NSManagedObjectContext: \(name)>"
        }
        return super.description
    }
}

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
    static let mediaType = CodingUserInfoKey(rawValue: "mediaType")!
}

public enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension NSManagedObject {
    /// Sets an optional value inside a NSManagedObject for the given key
    func setOptional<T>(_ value: T?, forKey key: String) {
        _setValue(value, forKey: key)
    }
    
    /// Returns the value for the given key, or nil, if the given value does not exist
    func getOptional<T>(forKey key: String) -> T? {
        return _getValue(forKey: key) as! T?
    }
    
    /// Sets an optional `Int` inside a NSManagedObject as an `Int64` for the given key
    func setOptionalInt(_ value: Int?, forKey key: String) {
        _setValue(value == nil ? nil : Int64(value!), forKey: key)
    }
    
    /// Returns the value for the given key, or nil, if the given value does not exist
    func getOptionalInt(forKey key: String) -> Int? {
        let value = _getValue(forKey: key) as! Int64?
        return value == nil ? nil : Int(value!)
    }
    
    /// Sets the given value inside a `NSManagedObject` for the given key
    func setTransformerValue<T>(_ value: T, forKey key: String) {
        _setValue(value, forKey: key)
    }
    
    /// Returns the value for the given key
    func getTransformerValue<T>(forKey key: String) -> T {
        _getValue(forKey: key) as! T
    }
    
    /// Sets the given `Int` as an `Int64` for the given key
    func setInt(_ value: Int, forKey key: String) {
        _setValue(Int64(value), forKey: key)
    }
    
    /// Returns the `Int` value for the given key
    func getInt(forKey key: String) -> Int {
        Int(_getValue(forKey: key) as! Int64)
    }
    
    /// Saves the enum value's raw type under the given key
    func setEnum<T: RawRepresentable>(_ value: T, forKey key: String) {
        _setValue(value.rawValue, forKey: key)
    }
    
    /// Returns the enum value for the given key
    func getEnum<T: RawRepresentable>(forKey key: String) -> T {
        let rawValue = _getValue(forKey: key) as! T.RawValue
        return T(rawValue: rawValue)!
    }
    
    /// Saves the enum value's raw type under the given key
    func setOptionalEnum<T: RawRepresentable>(_ value: T?, forKey key: String) {
        _setValue(value?.rawValue, forKey: key)
    }
    
    /// Returns the enum value for the given key
    func getOptionalEnum<T: RawRepresentable>(forKey key: String) -> T? {
        if let rawValue = _getValue(forKey: key) as? T.RawValue {
            // We force the result, to throw an exception, if the primitive value exists, but cannot be converted to the requested enum type
            return T(rawValue: rawValue)!
        }
        return nil
    }
    
    /// Convenience function that sets the given primitive value for the given key and calls all neccessary functions before and after
    private func _setValue(_ value: Any?, forKey key: String) {
        DispatchQueue.main.async { self.objectWillChange.send() }
        willChangeValue(forKey: key)
        setPrimitiveValue(value, forKey: key)
        didChangeValue(forKey: key)
    }
    
    /// Convenience function that returns the primitive value for the given key and calls all neccessary functions before and after
    private func _getValue(forKey key: String) -> Any? {
        willAccessValue(forKey: key)
        defer { didAccessValue(forKey: key) }
        return primitiveValue(forKey: key)
    }
}

public extension NSSet {
    /// Converts this `NSSet` into a `Set`
    func asSet<T>(of type: T.Type) -> Set<T> {
        return self as! Set<T>
    }
    
    func asArray<T: Hashable>(of type: T.Type) -> [T] {
        return Array<T>(self.asSet(of: type))
    }
    
    var isEmpty: Bool { self.count == 0 }
}

public extension NSManagedObjectContext {
    /// Creates and returns a new background context which is a child of this context.
    /// - Returns: The background context with this context set as its parent
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self
        context.name = "Background Context (\(Date()), Child of \(self.description))"
        return context
    }
}
