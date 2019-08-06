//
//  Log.swift
//  weatherTest
//
//  Created by Ghassen Ferchichi on 06/08/2019.
//  Copyright © 2019 Ghassen Ferchichi. All rights reserved.
//

import Foundation

//Different logs possible
//Verbose   - display EVERYTHING
//Debug     - display debugging stuff (and info, warnings and errors)
//Info      - display nice information (and warnings and errors)
//Warning   - display warnings (and errors)
//Error     - display error ONLY
enum LogLevel {
    case disable
    case verbose
    case debug
    case info
    case warning
    case error
}

open class Log {
    static private var dateFormatter = DateFormatter()
    static private let indicators = [
        LogLevel.disable: "",
        LogLevel.verbose: "😈",
        LogLevel.debug: "🤓",
        LogLevel.info: "ℹ️",
        LogLevel.warning: "⚠️",
        LogLevel.error: "⛔️"
    ]
    
    private static func minLevel() -> LogLevel {
        #if RELEASE
        return .disable
        #else
        return .verbose
        #endif
    }
    
    private static func injectIndicator(message: Any, level: LogLevel) -> String {
        return indicators[level]! + " " + String(describing: message)
    }
    
    public static func verbose(_ message: Any, separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        switch Log.minLevel() {
        case .verbose:
            log(injectIndicator(message: message, level: .verbose), separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
        default: break
        }
    }
    
    public static func debug(_ message: Any, separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        switch Log.minLevel() {
        case .verbose, .debug:
            log(injectIndicator(message: message, level: .debug), separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
        default: break
        }
    }
    
    public static func info(_ message: Any, separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        switch Log.minLevel() {
        case .verbose, .debug, .info:
            log(injectIndicator(message: message, level: .info), separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
        default: break
        }
    }
    
    public static func warning(_ message: Any, separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        switch Log.minLevel() {
        case .verbose, .debug, .info, .warning:
            log(injectIndicator(message: message, level: .warning), separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
        default: break
        }
    }
    
    public static func error(_ message: Any, separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        switch Log.minLevel() {
        case .verbose, .debug, .info, .warning, .error:
            log(injectIndicator(message: message, level: .error), separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
        default: break
        }
    }
    
    private static func log(_ message: Any, separator: String, terminator: String, file: String, line: Int, column: Int, function: String) {
        let now = Date()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        print("[\(dateFormatter.string(from: now))] \((file as NSString).lastPathComponent):\(line) \(message)")
    }
}
