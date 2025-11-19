//
//  DraftPick.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/23/25.
//

import Foundation

public struct DraftPick: Codable {
    var leagueId: UUID
    var userId: UUID
    var round: Int
    var pick: Int
    var playerId: UUID?
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case round = "round"
        case pick = "pick"
        case playerId = "player_id"
    }
}
