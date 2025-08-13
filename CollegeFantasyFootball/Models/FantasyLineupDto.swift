//
//  FantasyLineupDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation

struct FantasyLineupDto: Codable {
    let fantasyLeague: FantasyLeague
    let user: User
    let week: Int
    let season: Int
    
    let qb: Player?
    let rb: Player?
    let te: Player?
    let wr1: Player?
    let wr2: Player?
    let flex: Player?
    let pk: Player?
    let p: Player?
    
    enum CodingKeys: String, CodingKey {
        case fantasyLeague = "fantasy_league"
        case user = "user"
        case week = "week"
        case season = "season"
        case qb = "qb"
        case rb = "rb"
        case te = "te"
        case wr1 = "wr1"
        case wr2 = "wr2"
        case flex = "flex"
        case pk = "pk"
        case p = "p"
    }
    
    static let mock = FantasyLineupDto(
        fantasyLeague: FantasyLeague.mock,
        user: User.mock,
        week: 1,
        season: 2025,
        qb: nil,
        rb: nil,
        te: nil,
        wr1: nil,
        wr2: nil,
        flex: nil,
        pk: nil,
        p: nil
    )
}
