//
//  FantasyLeagueDto.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 9/1/25.
//

import Foundation

public struct FantasyLeagueDto: Codable {
    var id: UUID
    var owner: User
    var currentSeason: Int
    
    var leagueName: String
    
    var draftDate: Date
    var draftInProgress: Bool
    var draftComplete: Bool
    
    var ppr: Bool
    // QB STATS
    var pointsPerCompletion: Double
    var pointsPerPassYd: Double
    var pointsPer10PassYds: Double
    var pointsPer25PassYds: Double
    var pointsPerPassTd: Double
    var pointsPerInt: Double
    // RB STATS
    var pointsPerRushYd: Double
    var pointsPer10RushYds: Double
    var pointsPerRushTd: Double
    // WR/TE STATS
    var pointsPerRec: Double
    var pointsPerRecYd: Double
    var pointsPer10RecYds: Double
    var pointsPerRecTd: Double
    // K/P STATS
    var pointsPerFgMade: Double
    var pointsPerFgMiss: Double
    var pointsPerXpMade: Double
    var pointsPerXpMiss: Double
    var pointsPerPuntIn20: Double
    // SPECIAL TEAM STATS
    var pointsPerKickReturnTd: Double
    var pointsPerPuntReturnTd: Double
    // OTHER STATS
    var pointsPerFumbleLost: Double
    
    // OTHER SETTINGS
    var includeKickers: Bool
    var includePunters: Bool
    var includeDefense: Bool
    
    static func selectAll() -> String {
        return """
            id,
            owner:User!FantasyLeague_owner_id_fkey(*),
            league_name,
            current_season,
            draft_date,
            draft_in_progress,
            draft_complete,
            ppr,
            points_per_completion,
            points_per_pass_yd,
            points_per_10_pass_yds,
            points_per_25_pass_yds,
            points_per_pass_td,
            points_per_int,
            points_per_rush_yd,
            points_per_10_rush_yds,
            points_per_rush_td,
            points_per_rec,
            points_per_rec_yd,
            points_per_10_rec_yds,
            points_per_rec_td,
            points_per_kr_td,
            points_per_pr_td,
            points_per_fg_made,
            points_per_fg_miss,
            points_per_xp_made,
            points_per_xp_miss,
            points_per_punt_in_20,
            points_per_fumble_lost,
            include_defense,
            include_punters,
            include_kickers
            """
    }
    
    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case owner = "owner"
        case leagueName = "league_name"
        case currentSeason = "current_season"
        case draftDate = "draft_date"
        case draftInProgress = "draft_in_progress"
        case draftComplete = "draft_complete"
        case ppr = "ppr"
        
        case pointsPerCompletion = "points_per_completion"
        case pointsPerPassYd = "points_per_pass_yd"
        case pointsPer10PassYds = "points_per_10_pass_yds"
        case pointsPer25PassYds = "points_per_25_pass_yds"
        case pointsPerPassTd = "points_per_pass_td"
        case pointsPerInt = "points_per_int"
        
        case pointsPerRushYd = "points_per_rush_yd"
        case pointsPer10RushYds = "points_per_10_rush_yds"
        case pointsPerRushTd = "points_per_rush_td"
        
        case pointsPerRec = "points_per_rec"
        case pointsPerRecYd = "points_per_rec_yd"
        case pointsPer10RecYds = "points_per_10_rec_yds"
        case pointsPerRecTd = "points_per_rec_td"
        
        case pointsPerFgMade = "points_per_fg_made"
        case pointsPerFgMiss = "points_per_fg_miss"
        case pointsPerXpMade = "points_per_xp_made"
        case pointsPerXpMiss = "points_per_xp_miss"
        case pointsPerPuntIn20 = "points_per_punt_in_20"
        
        case pointsPerKickReturnTd = "points_per_kr_td"
        case pointsPerPuntReturnTd = "points_per_pr_td"
        
        case pointsPerFumbleLost = "points_per_fumble_lost"
        
        case includeDefense = "include_defense"
        case includePunters = "include_punters"
        case includeKickers = "include_kickers"
    }
}


extension FantasyLeagueDto {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone.current // send with your local timezone offset
        return formatter
    }()
}
