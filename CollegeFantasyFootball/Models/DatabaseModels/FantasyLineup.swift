//
//  FantasyLineup.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/27/25.
//
import Foundation

struct FantasyLineup: Codable {
    var leagueId: UUID
    var userId: UUID
    var week: Int
    var season: Int
    
    var qbId: Int?
    var rbId: Int?
    var teId: Int?
    var wr1Id: Int?
    var wr2Id: Int?
    var flexId: Int?
    var pkId: Int?
    var pId: Int?
    
    var playerIds: [Int] {
        var nonNilIds = [Int]()
        
        if qbId != nil {
            nonNilIds.append(qbId!)
        }
        if rbId != nil {
            nonNilIds.append(rbId!)
        }
        if wr1Id != nil {
            nonNilIds.append(wr1Id!)
        }
        if wr2Id != nil {
            nonNilIds.append(wr2Id!)
        }
        if teId != nil {
            nonNilIds.append(teId!)
        }
        if flexId != nil {
            nonNilIds.append(flexId!)
        }
        if pId != nil {
            nonNilIds.append(pId!)
        }
        if pkId != nil {
            nonNilIds.append(pkId!)
        }
        return nonNilIds
    }
    
    static var mock = FantasyLineup(
        leagueId: UUID(),
        userId: UUID(),
        week: 0,
        season: 0,
        qbId: nil,
        rbId: nil,
        teId: nil,
        wr1Id: nil,
        wr2Id: nil,
        flexId: nil,
        pkId: nil,
        pId: nil
    )
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case week = "week"
        case season = "season"
        
        case qbId = "qb_id"
        case rbId = "rb_id"
        case teId = "te_id"
        case wr1Id = "wr1_id"
        case wr2Id = "wr2_id"
        case flexId = "flex_id"
        case pkId = "pk_id"
        case pId = "p_id"
    }
}
