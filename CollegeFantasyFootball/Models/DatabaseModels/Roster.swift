//
//  Roster.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/10/25.
//

import Foundation

struct Roster: Codable {
    let userId: UUID
    let leagueId: UUID
    let week: Int
    let startingQbId: Int?
    let startingRbId: Int?
    let startingWr1Id: Int?
    let startingWr2Id: Int?
    let startingTeId: Int?
    let startingPId: Int?
    let startingPkId: Int?
    let bench1Id: Int?
    let bench2Id: Int?
    let bench3Id: Int?
    let bench4Id: Int?
    let bench5Id: Int?
    
    var nonNilIds: [Int] {
        var ids = [Int]()
        
        if let id = startingQbId {
            ids.append(id)
        }
        if let id = startingRbId {
            ids.append(id)
        }
        if let id = startingWr1Id {
            ids.append(id)
        }
        if let id = startingWr2Id {
            ids.append(id)
        }
        if let id = startingTeId {
            ids.append(id)
        }
        if let id = startingPId {
            ids.append(id)
        }
        if let id = startingPkId {
            ids.append(id)
        }
        if let id = bench1Id {
            ids.append(id)
        }
        if let id = bench2Id {
            ids.append(id)
        }
        if let id = bench3Id {
            ids.append(id)
        }
        if let id = bench4Id {
            ids.append(id)
        }
        if let id = bench5Id {
            ids.append(id)
        }
        
        
        return ids
    }
    
    static let mock = Roster(
        userId: UUID(),
        leagueId: UUID(),
        week: 1,
        startingQbId: 102597,
        startingRbId: 4366640,
        startingWr1Id: 4367560,
        startingWr2Id: 4427225,
        startingTeId: 4373687,
        startingPId: 4567942,
        startingPkId: 4566164,
        bench1Id: 4367069,
        bench2Id: nil,
        bench3Id: nil,
        bench4Id: nil,
        bench5Id: nil
    )
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case leagueId = "league_id"
        case week = "week"
        case startingQbId = "starting_qb_id"
        case startingRbId = "starting_rb_id"
        case startingWr1Id = "starting_wr1_id"
        case startingWr2Id = "starting_wr2_id"
        case startingTeId = "starting_te_id"
        case startingPkId = "starting_pk_id"
        case startingPId = "starting_p_id"
        case bench1Id = "bench1_id"
        case bench2Id = "bench2_id"
        case bench3Id = "bench3_id"
        case bench4Id = "bench4_id"
        case bench5Id = "bench5_id"
    }
}
