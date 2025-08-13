//
//  GameSchedule.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/6/25.
//

import Foundation

struct GameSchedule: Codable {
    let id: Int
    let season: Int
    let week: Int
    let seasonType: String
    let homeTeam: Team
    let awayTeam: Team
    let homePoints: UInt?
    let awayPoints: UInt?
    let startTimeTbd: Bool
    let startDate: Date?
    let completed: Bool
    let conferenceGame: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case season = "season"
        case week = "week"
        case seasonType = "season_type"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case homePoints = "home_points"
        case awayPoints = "away_points"
        case startTimeTbd = "start_time_tbd"
        case startDate = "start_date"
        case completed = "completed"
        case conferenceGame = "conference_game"
    }
}
