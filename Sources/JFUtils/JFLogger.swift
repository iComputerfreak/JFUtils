//
//  JFLogger.swift
//
//
//  Created by Jonas Frey on 09.06.19.
//

import Foundation

/// Represents a collection of logging functions
struct JFLogger {
    
    /// Represents a logging level used by the JFLogger
    public enum JFLogLevel: String {
        case debug
        case info
        case warn
        case error
        case fatal
    }
    
    /// Prints a debug message on the console
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func debug(_ message: String, showFuncOnly: Bool = true,
                             file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, showFuncOnly: showFuncOnly, file: file, function: function, line: line)
    }
    
    /// Prints an info message on the console
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func info(_ message: String, showFuncOnly: Bool = true,
                            file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, showFuncOnly: showFuncOnly, file: file, function: function, line: line)
    }
    
    /// Prints a warning message on the console
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func warn(_ message: String, showFuncOnly: Bool = true,
                            file: String = #file, function: String = #function, line: Int = #line) {
        log(.warn, message, showFuncOnly: showFuncOnly, file: file, function: function, line: line)
    }
    
    /// Prints an error message on the console
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func error(_ message: String, showFuncOnly: Bool = true,
                             file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, showFuncOnly: showFuncOnly, file: file, function: function, line: line)
    }
    
    /// Prints a fatal message on the console
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func fatal(_ message: String, showFuncOnly: Bool = true,
                             file: String = #file, function: String = #function, line: Int = #line) {
        log(.fatal, message, showFuncOnly: showFuncOnly, file: file, function: function, line: line)
    }
    
    /// Prints a message on the console with the specified log level
    /// - Parameter level: The log level to use
    /// - Parameter message: The message to print
    /// - Parameter showFuncOnly: Whether to show only the function name or the file, line number and function name
    /// - Parameter file: The file path the function got called
    /// - Parameter function: The function the function got called in
    /// - Parameter line: The line number of the function call
    public static func log(_ level: JFLogLevel, _ message: String, showFuncOnly: Bool = true,
                           file: String = #file, function: String = #function, line: Int = #line) {
        let fullLocation = "\(file.components(separatedBy: "/").last!):\(line):\(function)"
        print("[\(level.rawValue.uppercased())] \(showFuncOnly ? function : fullLocation): \(message)")
    }
    
}
