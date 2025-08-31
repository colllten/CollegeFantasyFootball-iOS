//
//  DraftBoardDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/31/25.
//

import Foundation

struct DraftBoardDto: Codable, SqlSelectable {
    let league: FantasyLeague
    let user: User
    let player: Player
    let season: UInt16
    
    static func selectAll(keys: String...) -> String {
        return """
            league:\(keys[0]),
            user:\(keys[1]),
            player:\(keys[2]),
            season
            """
    }
    
    enum CodingKeys: String, CodingKey {
        case league = "league"
        case user = "user"
        case player = "player"
        case season = "season"
    }
}
