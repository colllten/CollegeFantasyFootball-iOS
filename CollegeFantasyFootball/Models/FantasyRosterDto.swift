//
//  FantasyRosterDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation

struct FantasyRosterDto: Codable {
    let fantasyLeague: FantasyLeague
    let user: User
    let season: Int
    
    var player1: Player?
    var player2: Player?
    var player3: Player?
    var player4: Player?
    var player5: Player?
    var player6: Player?
    var player7: Player?
    var player8: Player?
    var player9: Player?
    var player10: Player?
    var player11: Player?
    var player12: Player?
    
    var rosterPlayers: [Player] {
        var players: [Player] = []
        if player1 != nil { players.append(player1!) }
        if player2 != nil { players.append(player2!) }
        if player3 != nil { players.append(player3!) }
        if player4 != nil { players.append(player4!) }
        if player5 != nil { players.append(player5!) }
        if player6 != nil { players.append(player6!) }
        if player7 != nil { players.append(player7!) }
        if player8 != nil { players.append(player8!) }
        if player9 != nil { players.append(player9!) }
        if player10 != nil { players.append(player10!) }
        if player11 != nil { players.append(player11!) }
        if player12 != nil { players.append(player12!) }
        
        return players
    }
    
    // All player slots as writable key paths
    static let slots: [WritableKeyPath<FantasyRosterDto, Player?>] = [
        \.player1, \.player2, \.player3, \.player4, \.player5, \.player6,
         \.player7, \.player8, \.player9, \.player10, \.player11, \.player12
    ]
    
    // First empty slot key path
    var firstEmptySlotKeyPath: WritableKeyPath<FantasyRosterDto, Player?>? {
        Self.slots.first { self[keyPath: $0] == nil }
    }
    
    // Assign to first empty slot; returns false if roster is full
    mutating func assignToFirstEmptySlot(_ player: Player) -> Bool {
        guard let kp = firstEmptySlotKeyPath else { return false }
        self[keyPath: kp] = player
        return true
    }
    
    enum CodingKeys: String, CodingKey {
        case fantasyLeague = "fantasy_league"
        case user = "user"
        case season = "season"
        
        case player1 = "player_1"
        case player2 = "player_2"
        case player3 = "player_3"
        case player4 = "player_4"
        case player5 = "player_5"
        case player6 = "player_6"
        case player7 = "player_7"
        case player8 = "player_8"
        case player9 = "player_9"
        case player10 = "player_10"
        case player11 = "player_11"
        case player12 = "player_12"
    }
}
