//
//  DictionaryExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

public extension Dictionary {
    
    /// Merges the given dictionary with this dictionary by overriding the existing values with the given new values
    func merging(_ other: [Key : Value]) -> [Key : Value] {
        return self.merging(other, uniquingKeysWith: { _, new in new })
    }
    
    /// Merges the given dictionary with this dictionary by overriding the existing values with the given new values
    mutating func merge(_ other: [Key : Value]) {
        self.merge(other, uniquingKeysWith: { _, new in new })
    }
}

public extension Dictionary where Key == String, Value == Any? {
    /// Returns the dictionary as a string of HTTP arguments, percent escaped
    ///
    ///     [key1: "test", key2: "Hello World"].percentEscaped()
    ///     // Returns "key1=test&key2=Hello%20World"
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value ?? "null")".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}
