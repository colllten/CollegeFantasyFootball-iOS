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
}
