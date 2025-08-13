//
//  FantasyGameDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 6/8/25.
//

import Foundation

struct FantasyGameDto: Codable {
    let id: UUID
    let fantasyLeague: FantasyLeague
    let homeUser: User?
    let awayUser: User?
    let week: Int
    let homeScore: Float?
    let awayScore: Float?
    let winningUser: User?
    let isPlayoff: Bool
    
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
