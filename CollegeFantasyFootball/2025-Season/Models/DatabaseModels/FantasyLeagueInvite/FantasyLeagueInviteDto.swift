//
//  FantasyLeagueInviteDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/14/25.
//

import Foundation

struct FantasyLeagueInviteDto: Identifiable, Codable {
    let id = UUID()
    let leagueId: UUID
    let receiverId: UUID
    let senderId: UUID
    let accepted: Bool?
    let senderUsername: SenderUsername
    let receiverUsername: ReceiverUsername
    let leagueName: LeagueName
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case receiverId = "receiver_id"
        case senderId = "sender_id"
        case accepted = "accepted"
        case senderUsername = "sender_username"
        case receiverUsername = "receiver_username"
        case leagueName = "league_name"
    }
    
    struct SenderUsername: Codable {
        let username: String
    }
    
    struct ReceiverUsername: Codable {
        let username: String
    }
    
    struct LeagueName: Codable {
        let leagueName: String
        
        enum CodingKeys: String, CodingKey {
            case leagueName = "league_name"
        }
    }
}
