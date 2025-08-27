//
//  GameStats.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/26/25.
//

import Foundation

struct GameStats: Codable {
    var playerId: Int
    var gameId: Int
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
    
    enum CodingKeys: String, CodingKey {
        case playerId = "player_id"
        case gameId = "game_id"
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
