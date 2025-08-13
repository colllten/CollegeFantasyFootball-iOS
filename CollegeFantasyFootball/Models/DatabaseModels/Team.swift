//
//  Team.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/8/25.
//

import Foundation

struct Team: Codable {
    let id: Int
    let school: String
    let mascot: String?
    let abbreviation: String?
    let conference: String?
    let color: String?
    let alternateColor: String?
    let division: String?
    let classification: String?
    let logos: [String]?
    let alternateNames: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case school = "school"
        case mascot = "mascot"
        case abbreviation = "abbreviation"
        case conference = "conference"
        case color = "color"
        case alternateColor = "alternate_color"
        case division = "division"
        case classification = "classification"
        case logos = "logos"
        case alternateNames = "alternate_names"
    }
}
