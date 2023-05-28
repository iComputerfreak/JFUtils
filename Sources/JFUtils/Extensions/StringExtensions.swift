//
//  StringExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import Foundation

public extension CharacterSet {
    /// Returns the set of characters that are allowed in a URL query
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

public extension String {
    /// Returns a string without a given prefix
    ///
    ///     "abc def".removingPrefix("abc") // returns " def"
    ///     "cba def".revmoingPrefix("abc") // returns "cba def"
    ///
    /// - Parameter prefix: The prefix to remove, if it exists
    /// - Returns: The string without the given prefix
    func removingPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return String(self.dropFirst(prefix.count))
        }
        // If the prefix does not exist, leave the string as it is
        return String(self)
    }
    
    /// Returns a string without a given suffix
    ///
    ///     "abc def".removingSuffix("def") // returns "abc "
    ///     "abc fed".revmoingSuffix("def") // returns "abc fed"
    ///
    /// - Parameter suffix: The suffix to remove, if it exists
    /// - Returns: The string without the given suffix
    func removingSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(self.dropLast(suffix.count))
        }
        // If the prefix does not exist, leave the string as it is
        return String(self)
    }
    
    /// Removes a prefix from a string
    ///
    ///     let a = "abc def".removingPrefix("abc") // a is " def"
    ///     let b = "cba def".revmoingPrefix("abc") // b is "cba def"
    ///
    /// - Parameter prefix: The prefix to remove, if it exists
    /// - Returns: The string without the given prefix
    mutating func removePrefix(_ prefix: String) {
        if self.hasPrefix(prefix) {
            self.removeFirst(prefix.count)
        }
        // If the prefix does not exist, leave the string as it is
    }
    
    /// Removes a suffix from a string
    ///
    ///     let a = "abc def".removingSuffix("def") // a is "abc "
    ///     let b = "abc fed".revmoingSuffix("def") // b is "abc fed"
    ///
    /// - Parameter suffix: The suffix to remove, if it exists
    /// - Returns: The string without the given suffix
    mutating func removeSuffix(_ suffix: String) {
        if self.hasSuffix(suffix) {
            self.removeLast(suffix.count)
        }
        // If the prefix does not exist, leave the string as it is
    }
    
    func components(separatedBy separator: Character) -> [String] {
        self.components(separatedBy: String(separator))
    }
}

public extension StringProtocol {
    /// Pads this string by adding the given `paddingString` to the left, until a given length is reached.
    /// - Parameters:
    ///   - length: The minimum length of the resulting string
    ///   - paddingString: The string to use for the padding
    /// - Returns: The padded string of at least length `length`
    func padding(toLength length: Int, withPad paddingString: String = " ") -> String {
        var string = String(self)
        
        while string.count < length {
            string = paddingString + string
        }
        
        return string
    }
}

public extension LosslessStringConvertible {
    /// Pads this string by adding the given `paddingString` to the left, until a given length is reached.
    /// - Parameters:
    ///   - length: The minimum length of the resulting string
    ///   - paddingString: The string to use for the padding
    /// - Returns: The padded string of at least length `length`
    func padding(toLength length: Int, withPad paddingString: String = " ") -> String {
        return String(self).padding(toLength: length, withPad: paddingString)
    }
}
