//
//  GlobalFunctions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import Foundation

/// Throws a fatal error when called. Used for setting undefined values temporarily to make the code compile
///
/// Example:
///
///     let value: String = undefined() // Will compile as a String
///     print(value.components(separatedBy: " ") // Will not throw any compiler errors
public func undefined<T>(_ message: String = "") -> T {
    fatalError(message)
}

/// Returns the smaller non-nil object of the given two objects
/// - Parameters:
///   - x: The first object to compare
///   - y: The second object to compare
/// - Returns: The smaller non-nil object. If both objects are nil, the function returns nil.
public func min<T>(_ x: T?, _ y: T?) -> T? where T : Comparable {
    if x == nil {
        return y
    }
    if y == nil {
        return x
    }
    return min(x!, y!)
}

/// Returns the bigger non-nil object of the given two objects
/// - Parameters:
///   - x: The first object to compare
///   - y: The second object to compare
/// - Returns: The bigger non-nil object. If both objects are nil, the function returns nil.
public func max<T>(_ x: T?, _ y: T?) -> T? where T : Comparable {
    if x == nil {
        return y
    }
    if y == nil {
        return x
    }
    return max(x!, y!)
}

/// Overload of the default NSLocalizedString function that uses an empty comment
public func NSLocalizedString(_ key: String, tableName: String? = nil) -> String {
    NSLocalizedString(key, tableName: tableName, comment: "")
}

#if os(macOS)

public enum BashResult: Equatable {
    case success
    case failure(Int32)
    case argumentError
    
    init(status: Int32) {
        if status == 0 {
            self = .success
        } else {
            self = .failure(status)
        }
    }
}

/// Executes the given bash command and returns its result
/// - Parameters:
///   - command: The command or executable to execute
///   - arguments: The list of arguments to pass to the command
///   - noEnv: Whether to execute the command using `/usr/bin/env`
///   - currentDirectory: The current working directory for the command
///   - standardOutput: The standard output handle
///   - standardError: The standard error handle
/// - Throws: Any errors during the process execution
/// - Returns: The `BashResult`of the execution
@available(macOS 10.13, *)
@discardableResult
public func bash(_ command: String, arguments: [String] = [], noEnv: Bool = false, currentDirectory: String? = nil, standardOutput: Any = FileHandle.standardOutput, standardError: Any = FileHandle.standardError) throws -> BashResult {
    let proc = Process()
    if noEnv {
        proc.executableURL = URL(fileURLWithPath: command)
        proc.arguments = arguments
    } else {
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        proc.arguments = [command] + arguments
    }
    if let currentDirectory = currentDirectory {
        proc.currentDirectoryPath = currentDirectory
    }
    proc.standardOutput = standardOutput
    proc.standardError = standardError
    try proc.run()
    proc.waitUntilExit()
    // Return value 0 is success, everything else it failure
    return BashResult(status: proc.terminationStatus)
}

#endif
