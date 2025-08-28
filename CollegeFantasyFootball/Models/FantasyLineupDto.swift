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
    
    var qb: Player?
    var rb: Player?
    var te: Player?
    var wr1: Player?
    var wr2: Player?
    var flex: Player?
    var pk: Player?
    var p: Player?
    
    var fantasyLineup: FantasyLineup {
        FantasyLineup(
            leagueId: fantasyLeague.id,
            userId: user.id,
            week: week,
            season: season,
            qbId: qb?.id,
            rbId: rb?.id,
            teId: te?.id,
            wr1Id: wr1?.id,
            wr2Id: wr2?.id,
            flexId: flex?.id,
            pkId: pk?.id,
            pId: p?.id)
    }
    
    var playerIds: [Int] {
        var ids = [Int]()
        
        if let id = qb?.id {
            ids.append(id)
        }
        if let id = rb?.id {
            ids.append(id)
        }
        if let id = te?.id {
            ids.append(id)
        }
        if let id = wr1?.id {
            ids.append(id)
        }
        if let id = wr2?.id {
            ids.append(id)
        }
        if let id = flex?.id {
            ids.append(id)
        }
        if let id = pk?.id {
            ids.append(id)
        }
        if let id = p?.id {
            ids.append(id)
        }
        return ids
    }
    
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
