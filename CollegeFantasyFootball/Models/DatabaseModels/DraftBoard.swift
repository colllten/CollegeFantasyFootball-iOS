//
//  DraftBoard.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/28/25.
//

import Foundation

struct DraftBoard: Codable {
    let leagueId: UUID
    let userId: UUID
    let playerId: Int
    let season: Int
    
    private enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case playerId = "player_id"
        case season = "season"
    }
}
