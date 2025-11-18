//
//  Metadata.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/28/25.
//

import Foundation

struct Metadata: Codable {
    let conference: String
    let week: Int
    
    enum CodingKeys: String, CodingKey {
        case conference = "conference"
        case week = "week"
    }
}
