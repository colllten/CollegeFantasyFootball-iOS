//
//  FantasyGameScheduleViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation
import PostgREST

class FantasyGameScheduleViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    @Published var allFantasyGames: [FantasyGameDto] = []
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for FantasyGameScheduleView")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            allFantasyGames = try await fetchAllLeagueGames()
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            alertMessage = "Error loading data"
            showAlert = true
        }
    }
    
    private func fetchAllLeagueGames() async throws -> [FantasyGameDto] {
        LoggingManager
            .logInfo("Fetching all fantasy games in league: \(fantasyLeague.id)")
        
        let response: PostgrestResponse<[FantasyGameDto]> = try await supabase
            .from("FantasyGame")
            .select("""
                id,
                fantasy_league:FantasyLeague!FantasyGame_league_id_fkey(*),
                home_user:User!FantasyGame_home_user_id_fkey(*),
                away_user:User!FantasyGame_away_user_id_fkey(*),
                week,
                home_score,
                away_score,
                winning_user:User!FantasyGame_winner_user_id_fkey(*),
                is_playoff
                """)
            .eq("league_id", value: fantasyLeague.id) // TODO: year?
            .execute()
        return response.value
    }
}
