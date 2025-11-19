//
//  AppMetadata.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/13/25.
//

import Foundation

struct AppMetadata: Codable {
    let version: String
    let isRequired: Bool
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case isRequired = "is_required"
    }
}
