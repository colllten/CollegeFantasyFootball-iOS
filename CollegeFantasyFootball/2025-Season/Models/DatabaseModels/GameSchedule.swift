//
//  GameSchedule.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/26/25.
//

import Foundation

struct GameSchedule: Codable {
    let id: Int
    let season: Int
    let week: Int
    let seasonType: String
    let homeId: Int
    let awayId: Int
    let homePoints: UInt?
    let awayPoints: UInt?
    let startTimeTbd: Bool
    let startDate: Date?
    let completed: Bool
    let conferenceGame: Bool?
    
    static var mock = GameSchedule(
        id: 0,
        season: 0,
        week: 0,
        seasonType: "",
        homeId: 0,
        awayId: 0,
        homePoints: 0,
        awayPoints: 0,
        startTimeTbd: false,
        startDate: Date.now,
        completed: false,
        conferenceGame: false
    )
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case season = "season"
        case week = "week"
        case seasonType = "season_type"
        case homeId = "home_id"
        case awayId = "away_id"
        case homePoints = "home_points"
        case awayPoints = "away_points"
        case startTimeTbd = "start_time_tbd"
        case startDate = "start_date"
        case completed = "completed"
        case conferenceGame = "conference_game"
    }
}
