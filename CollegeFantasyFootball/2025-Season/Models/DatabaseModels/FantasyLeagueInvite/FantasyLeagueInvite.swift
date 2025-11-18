//
//  FantasyLeagueInvite.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/14/25.
//

import Foundation

struct FantasyLeagueInvite: Codable {
    let leagueId: UUID
    let receiverId: UUID
    let senderId: UUID
    let accepted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case receiverId = "receiver_id"
        case senderId = "sender_id"
        case accepted = "accepted"
    }
}
