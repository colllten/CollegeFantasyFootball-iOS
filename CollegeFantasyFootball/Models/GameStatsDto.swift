//
//  GameStats.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 6/11/25.
//

import Foundation

struct GameStatsDto: Codable {
    var player: Player
    var game: GameSchedule
    var season: Int
    
    var passingCompletions: Int
    var passingAttempts: Int
    var passingYds: Int
    var passingTd: Int
    var passingInt: Int
    
    var rushingCarries: Int
    var rushingYds: Int
    var rushingTd: Int
    
    var receivingRecs: Int
    var receivingYds: Int
    var receivingTd: Int
    
    var puntReturnYds: Int
    var puntReturnTd: Int
    var kickReturnYds: Int
    var kickReturnTd: Int
    
    var puntingIn20: Int
    
    var kickingXpMade: Int
    var kickingXpMiss: Int
    var kickingFgMade: Int
    var kickingFgMiss: Int
    
    var puntReturns: Int
    var kickReturns: Int
    
    var fumblesLost: Int
    
    static var mock = GameStatsDto(
        player: Player.mock,
        game: GameSchedule(
            id: 0,
            season: 0,
            week: 0,
            seasonType: "",
            homeId: 0,
            awayId: 0,
            homePoints: 0,
            awayPoints: 0,
            startTimeTbd: false,
            startDate: nil,
            completed: false,
            conferenceGame: nil
        ),
        season: 2025,
        passingCompletions: 20,
        passingAttempts: 26,
        passingYds: 250,
        passingTd: 1,
        passingInt: 0,
        rushingCarries: 10,
        rushingYds: -16,
        rushingTd: 0,
        receivingRecs: 0,
        receivingYds: 0,
        receivingTd: 0,
        puntReturnYds: 0,
        puntReturnTd: 0,
        kickReturnYds: 0,
        kickReturnTd: 0,
        puntingIn20: 5,
        kickingXpMade: 5,
        kickingXpMiss: 0,
        kickingFgMade: 0,
        kickingFgMiss: 0,
        puntReturns: 0,
        kickReturns: 0,
        fumblesLost: 0
    )
    
    func fantasyPoints(league: FantasyLeague) -> Double {
        var points = 0.0
        
        // QB STATS
        points += Double(passingCompletions) * league.pointsPerCompletion
        points += Double(passingYds) * league.pointsPerPassYd
        points += (Double(passingYds) / 10) * league.pointsPer10PassYds
        points += (Double(passingYds) / 25) * league.pointsPer25PassYds
        points += Double(passingTd) * league.pointsPerPassTd
        points += Double(passingInt) * league.pointsPerInt
        
        // RB STATS
        points += Double(rushingYds) * league.pointsPerRushYd
        points += (Double(rushingYds) / 10) * league.pointsPer10RushYds
        points += Double(rushingTd) * league.pointsPerRushTd
        
        // WR/TE STATS
        points += Double(receivingRecs) * league.pointsPerRec
        points += Double(receivingYds) * league.pointsPerRecYd
        points += (Double(receivingYds) / 10) * league.pointsPer10RecYds
        points += Double(receivingTd) * league.pointsPerRecTd
        
        // PK STATS
        if league.includeKickers {
            points += Double(kickingFgMade) * league.pointsPerFgMade
            points += Double(kickingFgMiss) * league.pointsPerFgMiss
            points += Double(kickingXpMade) * league.pointsPerXpMade
            points += Double(kickingXpMiss) * league.pointsPerXpMiss
        }
        
        // P STATS
        if league.includePunters {
            points += Double(puntingIn20) * league.pointsPerPuntIn20
        }
        
        // RETURN STATS
        // TODO: Add return yards?
        points += Double(kickReturnTd) * league.pointsPerKickReturnTd
        points += Double(puntReturnTd) * league.pointsPerPuntReturnTd
        
        
        
        return points
    }
    
    enum CodingKeys: String, CodingKey {
        case player = "player"
        case game = "game"
        case season = "season"
        
        case passingCompletions = "passing_completions"
        case passingAttempts = "passing_attempts"
        case passingYds = "passing_yds"
        case passingTd = "passing_td"
        case passingInt = "passing_int"
        
        case rushingCarries = "rushing_carries"
        case rushingYds = "rushing_yds"
        case rushingTd = "rushing_td"
        
        case receivingRecs = "receiving_recs"
        case receivingYds = "receiving_yds"
        case receivingTd = "receiving_td"
        
        case puntReturnYds = "punt_return_yds"
        case puntReturnTd = "punt_return_td"
        
        case kickReturnYds = "kick_return_yds"
        case kickReturnTd = "kick_return_td"
        
        case puntReturns = "punt_returns"
        case kickReturns = "kick_returns"
        
        case puntingIn20 = "punting_in_20"
        
        case kickingXpMade = "kicking_xp_made"
        case kickingXpMiss = "kicking_xp_miss"
        case kickingFgMade = "kicking_fg_made"
        case kickingFgMiss = "kicking_fg_miss"
        
        case fumblesLost = "fumbles_lost"
    }
}
