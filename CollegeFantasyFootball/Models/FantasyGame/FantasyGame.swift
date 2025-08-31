//
//  FantasyGame.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/28/25.
//

import Foundation

struct FantasyGame: Codable, SqlSelectable {
    let id: UUID
    let leagueId: UUID
    let homeUserId: UUID
    let homeScore: Int
    let awayUserId: UUID
    let awayScore: Int
    let winnerUserId: UUID
    let isPlayoff: Bool
    let week: UInt8
    
    static func selectAll(keys: String...) -> String {
        return """
            id,
            league_id,
            home_user_id,
            home_score,
            away_user_id,
            away_score,
            winner_user_id,
            is_playoff,
            week,
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case leagueId = "league_id"
        case homeUserId = "home_user_id"
        case homeScore = "home_score"
        case awayUserId = "away_user_id"
        case awayScore = "away_score"
        case winnerUserId = "winner_user_id"
        case isPlayoff = "is_playoff"
        case week = "week"
    }
}
