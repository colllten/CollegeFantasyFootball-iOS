import Foundation

public struct FantasyLeagueV2: Codable {
    var id: UUID
    var ownerId = ""
    var currentSeason = 2026 // TODO: Pull from config
    var leagueName = ""
    var draftDate: Date = .now
    var draftInProgress = false
    var draftComplete = false
    
    var ppr: Bool = false {
        didSet {
            if !ppr {
                pointsPerRec = 0.0
            } else {
                pointsPerRec = 1.0
            }
        }
    }
    // QB STATS
    var pointsPer25PassYds = 1.0
    var pointsPerPassTd = 4.0
    var pointsPerInt = -2.0
    // RB STATS
    var pointsPer10RushYds = 1.0
    var pointsPerRushTd = 6.0
    // WR/TE STATS
    var pointsPerRec = 0.0
    var pointsPer10RecYds = 1.0
    var pointsPerRecTd = 6.0
    // K/P STATS
    var pointsPerFgMade = 3.0
    var pointsPerFgMiss = -2.0
    var pointsPerXpMade = 1.0
    var pointsPerXpMiss = -1.0
    var pointsPerPuntIn20 = 2.0
    // SPECIAL TEAM STATS
    var pointsPerKickReturnTd = 6.0
    var pointsPerPuntReturnTd = 6.0
    // MISC STATS
    var pointsPerFumbleLost = -2.0
    
    // OTHER SETTINGS
    var includeKickers = true
    var includePunters = true
    var includeDefense = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
        case leagueName = "league_name"
        case currentSeason = "current_season"
        case draftDate = "draft_date"
        case draftInProgress = "draft_in_progress"
        case draftComplete = "draft_complete"
        case ppr = "ppr"
        
        case pointsPer25PassYds = "points_per_25_pass_yds"
        case pointsPerPassTd = "points_per_pass_td"
        case pointsPerInt = "points_per_int"
        
        case pointsPer10RushYds = "points_per_10_rush_yds"
        case pointsPerRushTd = "points_per_rush_td"
        
        case pointsPerRec = "points_per_rec"
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
        
    init(
        id: UUID,
        ownerId: UUID,
        currentSeason: Int,
        leagueName: String,
        draftDate: Date,
        draftInProgress: Bool = false,
        draftComplete: Bool = false,
        ppr: Bool = false,
        pointsPer25PassYds: Int = 1,
        pointsPerPassTd: Int = 1,
        pointsPerInt: Int = 1,
        pointsPer10RushYds: Int = 1,
        pointsPerRushTd: Int = 1,
        pointsPerRec: Int = 1,
        pointsPer10RecYds: Int = 1,
        pointsPerRecTd: Int = 1,
        pointsPerFgMade: Int = 1,
        pointsPerFgMiss: Int = 1,
        pointsPerXpMade: Int = 1,
        pointsPerXpMiss: Int = 1,
        pointsPerPuntIn20: Int = 1,
        pointsPerKickReturnTd: Int = 1,
        pointsPerPuntReturnTd: Int = 1,
        pointsPerFumbleLost: Int = 1,
        includeKickers: Bool = false,
        includePunters: Bool = false,
        includeDefense: Bool = false,
    ) {
        self.id = id
        self.ownerId = ownerId.uuidString
        self.currentSeason = currentSeason
        self.leagueName = leagueName
        self.draftInProgress = draftInProgress
        self.draftComplete = draftComplete
        self.draftDate = draftDate
    }
    
    static let mock = FantasyLeagueV2(
        id: UUID(uuidString: "ad7a1787-544f-4af2-a623-1f60ce0ce188")!,
        ownerId: UUID(uuidString: "db721dfe-ed19-4d09-8ce8-5ef199662390")!,
        currentSeason: 2025,
        leagueName: "Test League",
        draftDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
        draftInProgress: false,
        draftComplete: false)
    
    static let newLeague = FantasyLeagueV2(
        id: UUID(),
        ownerId: UUID(),
        currentSeason: 2025,
        leagueName: "",
        draftDate: Date.now)
    
    static let emptyLeague = FantasyLeagueV2(
        id: UUID(),
        ownerId: UUID(),
        currentSeason: 2025,
        leagueName: "",
        draftDate: Calendar.current.startOfDay(for: .now))
}


extension FantasyLeagueV2 {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
