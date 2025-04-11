//
//  LoggingManager.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import Foundation
import os

/// Static class for managing loggers
class LoggingManager {
    private static let subsystem = "com.coltenglover"
    
    /// General logger for events occurring in view models, etc.
    static let general = Logger(subsystem: subsystem, category: "General")
    
    /// Logger for communications to Supabase
    static let database = Logger(subsystem: subsystem, category: "Database")
    
    /// Logger for communications over network (API calls, etc.)
    static let network = Logger(subsystem: subsystem, category: "Network")
    
    /// Logger for UI events
    static let ui = Logger(subsystem: subsystem, category: "UI")
}
