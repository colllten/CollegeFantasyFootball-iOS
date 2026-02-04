//
//  AppConfig.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/21/25.
//

import Foundation

struct AppConfig {
    static let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as! String
    static let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_PUBLISHABLE_KEY") as! String
    
    static let CURRENT_SEASON = 2026
    
    // TODO: Review
    private static let LAST_DRAFT_MONTH = 8
    private static let LAST_DRAFT_DAY = 29
    private static let LAST_DRAFT_YEAR = 2026
    
    static let LAST_DAY_DRAFT = Calendar
        .current
        .date(
            from: DateComponents(
                calendar: .current,
                year: LAST_DRAFT_YEAR,
                month: LAST_DRAFT_MONTH,
                day: LAST_DRAFT_DAY
            )
        ) ?? .now
}
