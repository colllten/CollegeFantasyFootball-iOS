//
//  Player.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/25/25.
//

import Foundation

struct Player: Codable, Hashable {
    let id: Int
    let season: Int
    let firstName: String
    let lastName: String
    let height: Int
    let weight: Int
    let jersey: Int
    let position: String
    let teamId: Int
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    static var positionOrder: [String : Int] = [
        "QB" : 0,
        "RB" : 1,
        "TE" : 2,
        "WR" : 3,
        "P"  : 4,
        "PK" : 5
    ]
    
    static var mock = Player(
        id: 1,
        season: 2025,
        firstName: "C",
        lastName: "G",
        height: 10,
        weight: 10,
        jersey: 10,
        position: "WR",
        teamId: 154
    )
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case season = "season"
        case firstName = "first_name"
        case lastName = "last_name"
        case height = "height"
        case weight = "weight"
        case jersey = "jersey"
        case position = "position"
        case teamId = "team_id"
    }
}
