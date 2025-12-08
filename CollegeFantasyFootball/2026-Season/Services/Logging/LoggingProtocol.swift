//
//  LoggingProtocol.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/20/25.
//

import Foundation

protocol LoggingProtocol {
    func logDebug(_ message: String)
    func logInfo(_ message: String)
    func logWarning(_ message: String)
    func logError(_ message: String)
}
