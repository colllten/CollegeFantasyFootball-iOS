//
//  LoggingManager.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import Foundation
import os

/// Static class for managing loggers
@MainActor
public class LoggingManager {
    private static let subsystem = "com.coltenglover"
    
    private static var logs: [LogEntry] = []
    private static let logQueue = DispatchQueue(label: "com.coltenglover.LoggingQueue")
    
    /// General logger for events occurring in view models, etc.
    private static let general = Logger(subsystem: subsystem, category: "General")
    
    public static func logInfo(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.info("\(message)")
        saveLog(level: "INFO", message: message)
    }
    
    public static func logWarning(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.warning("\(message)")
        saveLog(level: "WARNING", message: message)
    }
    
    public static func logError(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.error("\(message)")
        saveLog(level: "ERROR", message: message)
    }
    
    public static func getLogs() -> [LogEntry] {
        logQueue.sync { logs }
    }
    
    public static func clearLogs() {
        logQueue.sync { logs.removeAll() }
    }
    
    private static func saveLog(level: String, message: String) {
        let entry = LogEntry(level: level, message: message, timestamp: Date())
        logQueue.sync {
            logs.append(entry)
        }
    }
    
    public struct LogEntry: Codable {
        let level: String
        let message: String
        let timestamp: Date
    }
}
