//
//  HomeViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation
import PostgREST
import Supabase
import SwiftUI

class HomeViewModel: BaseViewModel {
    @Published var fantasyLeagues: [FantasyLeague] = []
    
    @Published var games: [GameSchedule] = []
    var selectedWeekGames: [GameSchedule] {
        games.filter { game in
            game.week == weekSelection
        }
    }
    
    @Published var weekSelection = 1
    var weeks = 1...10
    
    @Published var hasUnansweredNotifications = false
    
    @Published var updateAlertMessage = ""
    @Published var showUpdateAlert = false
        
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for HomeView")
        
        isLoading = true
        do {
            let appMetadata = try await fetchLatestAppMetadata()
            if let currentAppVersion = UIApplication.appVersion,
               currentAppVersion < appMetadata.version {
                throw AppVersionError.OUTDATED_VERSION
            }
            
            let leagueIds = try await fetchUserAffilliatedFantasyLeagueIds()
            fantasyLeagues = try await supabase
                .from("FantasyLeague")
                .select()
                .in("id", values: leagueIds)
                .execute()
                .value
                        
            games = try await fetchSchedules()
            
            hasUnansweredNotifications = try await fetchHasNotifications()
        } catch AppVersionError.OUTDATED_VERSION {
            updateAlertMessage = "Your version of the app is outdated. Please update in the App Store"
            showUpdateAlert = true
        } catch {
            LoggingManager
                .logError("Error fetching fantasy leagues: \(error)")
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 150_000_000) // 0.15s
                self.alertMessage = "Error loading data"
                self.showAlert = true
            }
        }
        
        isLoading = false
    }
    
    public func getTeamLogoStorageStr(teamId: Int, colorScheme: ColorScheme) -> URL? {
        let colorStr = colorScheme == .light
            ? "light"
            : "dark"
        
        do {
            return try supabase
                .storage
                .from("team-logos")
                .getPublicURL(path: "\(teamId)-\(colorStr).png")
        } catch {
            LoggingManager
                .logError("Error fetching team logo URL for team \(teamId)")
            return nil
        }
    }
    
    private func fetchLatestAppMetadata() async throws -> AppMetadata {
        LoggingManager
            .logInfo("Fetching latest app metadata")
        
        isLoading = true
        defer { isLoading = false }
        
        let metadatas: [AppMetadata] = try await supabase
            .from("AppMetadata")
            .select()
            .execute()
            .value
        
        print(UIApplication.appVersion)
        print(metadatas)
        
        return metadatas.max { m1, m2 in
            m1.version > m2.version
        }!
    }
    
    private func fetchUserAffilliatedFantasyLeagueIds() async throws -> [String] {
        guard let userId = AuthManager.shared.currentUser?.id else {
            return []
        }
        
        LoggingManager
            .logInfo("Getting fantasy league IDs for user \(userId)")
        
        let responseData: [[String : String]] = try await supabase
            .from("FantasyLeagueUser")
            .select("league_id")
            .eq("user_id", value: userId)
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
            .logInfo("Fetching fantasy leagues")
        
        return try await supabase
            .from("FantasyLeague")
            .select()
            .in("id", values: fantasyLeagueIds)
            .execute()
            .value
    }
    
    private func fetchSchedules() async throws -> [GameSchedule] {
        LoggingManager
            .logInfo("Fetching conference schedules")
        let response: PostgrestResponse<[GameSchedule]> = try await supabase
            .from("GameSchedule")
            .select("id, season, week, season_type, home_team:Team!GameSchedule_home_id_fkey(*), away_team:Team!GameSchedule_away_id_fkey(*), home_points, away_points, start_time_tbd, start_date, completed, conference_game")
            .eq("season", value: season)
            .execute()
        
        return response
            .value
            .sorted { game1, game2 in
                game1.week < game2.week
            }
    }
    
    private func fetchHasNotifications() async throws -> Bool {
        LoggingManager
            .logInfo("Fetching if user has unanswered notifications")
        
        guard let userId = AuthManager.shared.currentUser?.id else {
            return false
        }
        
        let invites: [FantasyLeagueInvite] = try await supabase
            .from("FantasyLeagueInvite")
            .select()
            .eq("receiver_id", value: userId)
            .execute()
            .value
        
        let unansweredInvites = invites.count { invite in
            invite.accepted == nil
        }
        
        return unansweredInvites > 0
    }
}

enum UserDefaultsError: Error {
    case noUserId
}

enum SupabaseQueryError: Error {
    case invalidColumnName
}

// TODO: FantasyGameView, calculate points, show user records, etc.
