//
//  DraftBoard.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/28/25.
//

import Foundation

struct DraftBoard: Codable, SqlSelectable {
    let leagueId: UUID
    let userId: UUID
    let playerId: Int
    let season: UInt16
    
    static func selectAll(keys: String...) -> String {
        return """
            league_id,
            user_id,
            player_id,
            season
            """
    }
    
    private enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case playerId = "player_id"
        case season = "season"
    }
}
