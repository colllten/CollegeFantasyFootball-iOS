//
//  SupabaseManager.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import Foundation
import Supabase

/// Singleton class to interface with Supabase
class SupabaseManager {
    /// Singleton instance
    public static let shared = SupabaseManager()
    /// Connection to Supabase
    public let client: SupabaseClient
    
    /// Constructor to initialize the client
    private init() {
        let supabaseUrl = URL(string: Secrets.SUPABASE_URL)!
        let supabaseKey = Secrets.SUPABASE_KEY
        
        client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey)
    }
}

enum SessionError: Error {
    case noUsername(String)
    case noEmail(String)
}
