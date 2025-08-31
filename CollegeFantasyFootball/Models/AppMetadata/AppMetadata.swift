//
//  AppMetadata.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/13/25.
//

import Foundation

struct AppMetadata: Codable, SqlSelectable {
    let version: String
    let isRequired: Bool
    
    static func selectAll(keys: String...) -> String {
        return """
            version,
            is_required
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case isRequired = "is_required"
    }
}
