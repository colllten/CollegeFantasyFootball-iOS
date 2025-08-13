//
//  FantasyGame.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/28/25.
//

import Foundation

// DB = FantasyLeagueGame
struct FantasyGame: Codable {
    var leagueId: UUID
    var homeId: UUID
    var awayId: UUID
    var week: UInt16
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case homeId = "home_id"
        case awayId = "away_id"
        case week = "week"
    }
}
