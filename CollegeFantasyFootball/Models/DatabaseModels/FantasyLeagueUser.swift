//
//  FantasyLeagueUser.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/13/25.
//

import Foundation

struct FantasyLeagueUser : Codable {
    let fantasyLeagueId: UUID
    let userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case fantasyLeagueId = "league_id"
        case userId = "user_id"
    }
}
