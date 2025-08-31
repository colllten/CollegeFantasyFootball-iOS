//
//  DraftPick.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/23/25.
//

import Foundation

public struct DraftPicks: Codable, SqlSelectable {
    let leagueId: UUID
    let userId: UUID
    let round: UInt8
    let pick: UInt16
    var playerId: UUID?
    let season: UInt16
    
    static func selectAll(keys: String...) -> String {
        return """
            league_id,
            user_id,
            round,
            pick,
            player_id,
            season
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case round = "round"
        case pick = "pick"
        case playerId = "player_id"
        case season = "season"
    }
}
