import Foundation

struct CreateFantasyLeagueFunctionParams : Encodable {
    let newOwnerId: UUID
    let newLeagueName: String
    let newCurrentSeason: Int
    let newDraftDate: Date // TODO: Format date
    
    let newPpr: Bool
    
    let newPointsPer25PassYds: Double
    let newPointsPerPassTd: Double
    let newPointsPerInt: Double
    
    let newPointsPer10RushYds: Double
    let newPointsPerRushTd: Double
    
    let newPointsPerRec: Double
    let newPointsPer10RecYds: Double
    let newPointsPerRecTd: Double
    
    let newPointsPerFgMade: Double
    let newPointsPerFgMiss: Double
    let newPointsPerXpMade: Double
    let newPointsPerXpMiss: Double
    
    let newPointsPerPuntIn20: Double
    
    let newPointsPerKickReturnTd: Double
    let newPointsPerPuntReturnTd: Double
    
    let newPointsPerFumbleLost: Double
    let newIncludeKickers: Bool
    let newIncludePunters: Bool
    let newIncludeDefense: Bool
    
    enum CodingKeys: String, CodingKey {
        case newOwnerId = "new_owner_id"
        case newLeagueName = "new_league_name"
        case newCurrentSeason = "new_current_season"
        case newDraftDate = "new_draft_date"
        
        case newPpr = "new_ppr"
        
        case newPointsPer25PassYds = "new_points_per_25_pass_yds"
        case newPointsPerPassTd = "new_points_per_pass_td"
        case newPointsPerInt = "new_points_per_int"
        
        case newPointsPer10RushYds = "new_points_per_10_rush_yds"
        case newPointsPerRushTd = "new_points_per_rush_td"
        
        case newPointsPerRec = "new_points_per_rec"
        case newPointsPer10RecYds = "new_points_per_10_rec_yds"
        case newPointsPerRecTd = "new_points_per_rec_td"
        
        case newPointsPerFgMade = "new_points_per_fg_made"
        case newPointsPerFgMiss = "new_points_per_fg_miss"
        case newPointsPerXpMade = "new_points_per_xp_made"
        case newPointsPerXpMiss = "new_points_per_xp_miss"
        
        case newPointsPerPuntIn20 = "new_points_per_punt_in_20"
        
        case newPointsPerKickReturnTd = "new_points_per_kr_td"
        case newPointsPerPuntReturnTd = "new_points_per_pr_td"
        
        case newPointsPerFumbleLost = "new_points_per_fumble_lost"
        case newIncludeKickers = "new_include_kickers"
        case newIncludePunters = "new_include_punters"
        case newIncludeDefense = "new_include_defense"
    }
}
