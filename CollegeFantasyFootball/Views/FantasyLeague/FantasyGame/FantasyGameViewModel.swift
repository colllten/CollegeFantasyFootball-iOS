//
//  FantasyGameViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation

class FantasyGameViewModel: BaseViewModel {
    @Published var fantasyGame: FantasyGameDto
    @Published var homeLineup = FantasyLineupDto.mock
    @Published var awayLineup = FantasyLineupDto.mock
    
    init(fantasyGame: FantasyGameDto) {
        self.fantasyGame = fantasyGame
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for FantasyGameView")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            fantasyGame = try await fetchFantasyGame()
            homeLineup = try await fetchFantasyLineup(userId: fantasyGame.homeUser!.id)
            awayLineup = try await fetchFantasyLineup(userId: fantasyGame.awayUser!.id)
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            alertMessage = "Error loading data"
            showAlert = true
        }
    }
    
    private func fetchFantasyGame() async throws -> FantasyGameDto {
        LoggingManager
            .logInfo("Fetching fantasy game \(fantasyGame.id)")
        
        return try await supabase
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
            .eq("id", value: fantasyGame.id)
            .single()
            .execute()
            .value
    }
    
    private func fetchFantasyLineup(userId: UUID) async throws -> FantasyLineupDto {
        LoggingManager
            .logInfo("Fetching fantasy lineup for user \(userId)")
        
        return try await supabase
            .from("FantasyLineup")
            .select("""
                fantasy_league:FantasyLeague!FantasyLineup_league_id_fkey(*),
                user:User!FantasyLineup_user_id_fkey(*),
                week,
                season,
                qb:Player!FantasyLineup_qb_id_season_fkey(*),
                rb:Player!FantasyLineup_rb_id_season_fkey(*),
                te:Player!FantasyLineup_season_te_id_fkey(*),
                wr1:Player!FantasyLineup_wr1_id_season_fkey(*),
                wr2:Player!FantasyLineup_wr2_id_season_fkey(*),
                flex:Player!FantasyLineup_flex_id_season_fkey(*),
                pk:Player!FantasyLineup_pk_id_season_fkey(*),
                p:Player!FantasyLineup_p_id_season_fkey(*)
                """)
            .eq("league_id", value: fantasyGame.fantasyLeague.id)
            .eq("user_id", value: userId)
            .eq("week", value: fantasyGame.week)
            .eq("season", value: season)
            .single()
            .execute()
            .value
    }
}
