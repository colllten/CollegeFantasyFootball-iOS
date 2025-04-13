//
//  HomeViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

class HomeViewModel: BaseViewModel {
    @Published var fantasyLeagues: [FantasyLeague] = []
    private let userId: String? = UserDefaults.standard.string(forKey: "userId")
    
    public func loadData() async {
        LoggingManager
            .general
            .info("Loading data for HomeView")
        
        isLoading = true
        do {
            let leagueIds = try await fetchUserAffilliatedFantasyLeagueIds()
            fantasyLeagues = try await fetchFantasyLeagues(fantasyLeagueIds: leagueIds)
        } catch {
            LoggingManager
                .general
                .error("Error fetching fantasy leagues: \(error)")
            previewPrint("Error fetching fantasy leagues: \(error)")
        }
        
        isLoading = false
    }
    
    private func fetchUserAffilliatedFantasyLeagueIds() async throws -> [String] {
        LoggingManager
            .general
            .info("Getting fantasy league IDs for user \(self.userId ?? "No user ID")")
        
        guard let userId else { throw UserDefaultsError.noUserId }
        
        let responseData: [[String : String]] = try await supabase
            .from("FantasyLeagueUser")
            .select("league_id")
            .eq("user_id", value: self.userId)
            .execute()
            .value
        
        let leagueIds: [String] = try responseData.map { row in
            guard let leagueId = row["league_id"] else { throw UserDefaultsError.noUserId }
            return leagueId
        }
        
        return leagueIds
    }
    
    private func fetchFantasyLeagues(fantasyLeagueIds: [String]) async throws -> [FantasyLeague] {
        LoggingManager
            .general
            .info("Fetching fantasy leagues")
        
        guard let userId else { throw SupabaseQueryError.invalidColumnName }
        
        return try await supabase
            .from("FantasyLeague")
            .select()
            .in("id", values: fantasyLeagueIds)
            .execute()
            .value
    }
    
    public func signOut() {
        UserDefaults.standard.set("", forKey: "userId")
    }
}

enum UserDefaultsError: Error {
    case noUserId
}

enum SupabaseQueryError: Error {
    case invalidColumnName
}
