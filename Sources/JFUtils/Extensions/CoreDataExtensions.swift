//
//  CoreDataExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import CoreData

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension NSManagedObject {
    /// Sets an optional value inside a NSManagedObject for the given key
    func setOptional<T>(_ value: T?, forKey key: String) {
        _setValue(value, forKey: key)
    }
    
    /// Returns the value for the given key, or nil, if the given value does not exist
    func getOptional<T>(forKey key: String, defaultValue: T? = nil) -> T? {
        guard let data = _getValue(forKey: key) else {
            return defaultValue
        }
        return data as! T?
    }
    
    /// Sets an optional `Int` inside a NSManagedObject as an `Int64` for the given key
    func setOptionalInt(_ value: Int?, forKey key: String) {
        _setValue(value == nil ? nil : Int64(value!), forKey: key)
    }
    
    /// Returns the value for the given key, or nil, if the given value does not exist
    func getOptionalInt(forKey key: String, defaultValue: Int? = nil) -> Int? {
        // If there is data, it must be an Int64
        if let data = _getValue(forKey: key) {
            return Int(data as! Int64)
        }
        return nil
    }
    
    /// Sets the given value inside a `NSManagedObject` for the given key
    func setTransformerValue<T>(_ value: T, forKey key: String) {
        _setValue(value, forKey: key)
    }
    
    /// Returns the value for the given key
    func getTransformerValue<T>(forKey key: String, defaultValue: T) -> T {
        guard let data = _getValue(forKey: key) else {
            return defaultValue
        }
        return data as! T
    }
    
    /// Sets the given `Int` as an `Int64` for the given key
    func setInt(_ value: Int, forKey key: String) {
        _setValue(Int64(value), forKey: key)
    }
    
    /// Returns the `Int` value for the given key
    func getInt(forKey key: String, defaultValue: Int = 0) -> Int {
        guard let data = _getValue(forKey: key) else {
            return defaultValue
        }
        return Int(data as! Int64)
    }
    
    /// Saves the enum value's raw type under the given key
    func setEnum<T: RawRepresentable>(_ value: T, forKey key: String) {
        _setValue(value.rawValue, forKey: key)
    }
    
    /// Returns the enum value for the given key
    func getEnum<T: RawRepresentable>(forKey key: String, defaultValue: T) -> T {
        guard let data = _getValue(forKey: key) else {
            return defaultValue
        }
        let rawValue = data as! T.RawValue
        return T(rawValue: rawValue)!
    }
    
    /// Saves the enum value's raw type under the given key
    func setOptionalEnum<T: RawRepresentable>(_ value: T?, forKey key: String) {
        _setValue(value?.rawValue, forKey: key)
    }
    
    /// Returns the enum value for the given key
    func getOptionalEnum<T: RawRepresentable>(forKey key: String, defaultValue: T? = nil) -> T? {
        if let data = _getValue(forKey: key) {
            // We force the result, to crash, if the primitive value exists, but cannot be converted to the requested enum type
            return T(rawValue: data as! T.RawValue)!
        }
        return nil
    }
    
    /// Saves the enum values' raw type under the given key
    func setEnumArray<T: RawRepresentable>(_ value: [T], forKey key: String) {
        setTransformerValue(value.map(\.rawValue), forKey: key)
    }
    
    /// Returns the enum values for the given key
    func getEnumArray<T: RawRepresentable>(forKey key: String, defaultValue: [T] = []) -> [T] {
        let rawValues: [T.RawValue] = getTransformerValue(forKey: key, defaultValue: defaultValue.map(\.rawValue))
        return rawValues.map { T(rawValue: $0)! }
    }
    
    /// Convenience function that sets the given primitive value for the given key and calls all neccessary functions before and after
    private func _setValue(_ value: Any?, forKey key: String) {
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
