//
//  LoggingService.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/20/25.
//

import Foundation
import os

final class LoggingService: LoggingProtocol {
    private static let subsystem = "com.coltenglover"
    
    private var logs: [LogEntry] = []
    private let logQueue = DispatchQueue(label: "com.coltenglover.LoggingQueue")
    
    /// General logger for events occurring in view models, etc.
    private let general = Logger(subsystem: subsystem, category: "General")
    
    public func logDebug(_ message: String) {
//        BaseViewModel.previewPrint(message)
        general.debug("\(message)")
        saveLog(level: "DEBUG", message: message)
    }
    
    public func logInfo(_ message: String) {
//        BaseViewModel.previewPrint(message)
        general.info("\(message)")
        saveLog(level: "INFO", message: message)
    }
    
    public func logWarning(_ message: String) {
//        BaseViewModel.previewPrint(message)
        general.warning("\(message)")
        saveLog(level: "WARNING", message: message)
    }
    
    public func logError(_ message: String) {
//        BaseViewModel.previewPrint(message)
        general.error("\(message)")
        saveLog(level: "ERROR", message: message)
    }
    
    public func getLogs() -> [LogEntry] {
        logQueue.sync { logs }
    }
    
    public func clearLogs() {
        logQueue.sync { logs.removeAll() }
    }
    
    private func saveLog(level: String, message: String) {
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
