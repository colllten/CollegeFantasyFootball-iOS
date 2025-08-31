//
//  FantasyLeagueInvite.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/14/25.
//

import Foundation

struct FantasyLeagueInvite: Codable, SqlSelectable {
    let leagueId: UUID
    let receiverId: UUID
    let senderId: UUID
    let accepted: Bool?
    
    static func selectAll(keys: String...) -> String {
        return """
            league_id,
            receiver_id,
            sender_id,
            accepted
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case receiverId = "receiver_id"
        case senderId = "sender_id"
        case accepted = "accepted"
    }
}
