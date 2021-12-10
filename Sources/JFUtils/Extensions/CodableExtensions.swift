//
//  CodableExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

public extension KeyedDecodingContainer {
    /// Tries to decode a value with any of the given keys
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode
    ///   - keys: The array of keys that the value may be associated with
    /// - Returns: The value associated with the first matching key that is not `nil`
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - Throws: `DecodingError.keyNotFound` if `self` does not have an non-nil entry
    ///   for any of the given keys.
    func decodeAny<T>(_ type: T.Type, forKeys keys: [Self.Key]) throws -> T where T: Decodable {
        for key in keys {
            if let value = try decodeIfPresent(T.self, forKey: key) {
                return value
            }
        }
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with any of the keys \(keys)")
        throw DecodingError.keyNotFound(keys.first!, context)
    }
}

public extension UnkeyedDecodingContainer {
    /// Tries to decode an array
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode
    /// - Returns: The array of values associated with this unkeyed container
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    mutating func decodeArray<T>(_ type: T.Type) throws -> [T] where T: Decodable {
        var returnValues = [T]()
        
        while !self.isAtEnd {
            returnValues.append(try self.decode(T.self))
        }
        
        return returnValues
    }
}
