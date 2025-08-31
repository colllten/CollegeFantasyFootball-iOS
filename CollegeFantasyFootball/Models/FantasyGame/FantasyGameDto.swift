//
//  FantasyGameDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 6/8/25.
//

import Foundation

struct FantasyGameDto: Codable, SqlSelectable {
    let id: UUID
    let fantasyLeague: FantasyLeague
    let homeUser: User?
    let awayUser: User?
    let week: UInt8
    let homeScore: Float16?
    let awayScore: Float16?
    let winningUser: User?
    let isPlayoff: Bool
    
    static func selectAll(keys: String...) -> String {
        return """
            id,
            fantasy_league:\(keys[0]),
            home_user:\(keys[1]),
            away_user:\(keys[2]),
            week,
            home_score,
            away_score,
            winning_user:\(keys[3]),
            is_playoff
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fantasyLeague = "fantasy_league"
        case homeUser = "home_user"
        case awayUser = "away_user"
        case week = "week"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case winningUser = "winning_user"
        case isPlayoff = "is_playoff"
    }
}
