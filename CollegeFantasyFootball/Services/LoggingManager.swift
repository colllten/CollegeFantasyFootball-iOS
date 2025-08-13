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
    
    /// General logger for events occurring in view models, etc.
    private static let general = Logger(subsystem: subsystem, category: "General")
    
    public static func logInfo(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.info("\(message)")
    }
    
    public static func logWarning(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.warning("\(message)")
    }
    
    public static func logError(_ message: String) {
        BaseViewModel.previewPrint(message)
        general.error("\(message)")
    }
}
