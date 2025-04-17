//
//  FantasyLeague.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

struct FantasyLeague: Codable {
    /// Unique ID
    var id = UUID()
    /// User ID of the fantasy league owner
    var ownerId = ""
    /// Current fantasy league season
    var currentSeason = 2024
    /// Name of the fantasy league
    var leagueName = ""
    /// Date of draft
    var draftDate: Date = .now
    /// Flag if draft is currently in progress
    var draftInProgress = false
    /// Flag if draft has finished
    var draftComplete = false
    
    // MARK: Fantasy league settings
    // TODO: Change all below to LET?
    var ppr: Bool = true {
        didSet {
            if !ppr {
                pointsPerRec = 0.0
            } else {
                pointsPerRec = 1.0
            }
        }
    }
    // QB STATS
    var pointsPerCompletion = 0.0
    var pointsPerPassYd = 0.0
    var pointsPer10PassYds = 1.0
    var pointsPer25PassYds = 1.0
    var pointsPerPassTd = 4.0
    var pointsPerInt = -2.0
    // RB STATS
    var pointsPerRushYd = 0.0
    var pointsPer10RushYds = 1.0
    var pointsPerRushTd = 4.0
    // WR/TE STATS
    var pointsPerRec = 1.0
    var pointsPerRecYd = 1.0
    var pointsPer10RecYds = 1.0
    var pointsPerRecTd = 4.0
    // K/P STATS
    var pointsPerFgMade = 2.0
    var pointsPerFgMiss = -2.0
    var pointsPerXpMade = 1.0
    var pointsPerXpMiss = -1.0
    var pointsPerPuntIn20 = 2.0
    // SPECIAL TEAM STATS
    var pointsPerKickReturnTd = 3.0
    var pointsPerPuntReturnTd = 3.0
    // OTHER STATS
    var pointsPerFumbleLost = -2.0
    
    // OTHER SETTINGS
    var includeKickers: Bool = true {
        didSet {
            // TODO: Reset punting stats
        }
    }
    var includePunters: Bool = true {
        didSet {
            // TODO: Reset punting stats
        }
    }
    var includeDefense: Bool = false {
        didSet {
            // TODO: Reset defense stats
        }
    }
    var customizePoints: Bool = true {
        didSet {
            // TODO: Reset to all stats
        }
    }
    
    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
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
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        ownerId = try container.decode(String.self, forKey: .ownerId)
        leagueName = try container.decode(String.self, forKey: .leagueName)
        
        let draftDateString = try container.decode(String.self, forKey: .draftDate)
        guard let date = FantasyLeague.dateFormatter.date(from: draftDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .draftDate, in: container, debugDescription: "Invalid date format")
        }
        draftDate = date
    }
    
    init(){}
    
    init(
        id: UUID,
        ownerId: UUID,
        currentSeason: Int,
        leagueName: String,
        draftDate: Date,
        draftInProgress: Bool = false,
        draftComplete: Bool = false,
        ppr: Bool = false,
        pointsPerCompletion: Int = 1,
        pointsPerPassYd: Int = 1,
        pointsPer10PassYds: Int = 1,
        pointsPer25PassYds: Int = 1,
        pointsPerPassTd: Int = 1,
        pointsPerInt: Int = 1,
        pointsPerRushYd: Int = 1,
        pointsPer10RushYds: Int = 1,
        pointsPerRushTd: Int = 1,
        pointsPerRec: Int = 1,
        pointsPerRecYd: Int = 1,
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
        customizePoints: Bool = false
    ) {
        self.id = id
        self.ownerId = ownerId.uuidString
        self.currentSeason = currentSeason
        self.leagueName = leagueName
        self.draftInProgress = draftInProgress
        self.draftComplete = draftComplete
        self.draftDate = draftDate
    }
    
    static let mock = FantasyLeague(
        id: UUID(uuidString: "831a296b-bf21-4017-8c46-92173971ed31")!,
        ownerId: UUID(uuidString: "831a296b-bf21-4017-8c46-92173971ed31")!,
        currentSeason: 2024,
        leagueName: "Mock League Name",
        draftDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
        draftInProgress: false,
        draftComplete: false)
}
