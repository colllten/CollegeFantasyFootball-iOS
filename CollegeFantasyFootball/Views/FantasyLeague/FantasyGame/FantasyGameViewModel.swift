//
//  FantasyGameViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation
import PostgREST

class FantasyGameViewModel: BaseViewModel {
    @Published var showAddPlayerToLineupSheet = false
    @Published var selectedPosition: String? = nil
    @Published var selectedLineup: FantasyLineupDto? = nil
    @Published var fantasyGame: FantasyGameDto
    
    @Published var homeLineup = FantasyLineupDto.mock
    @Published var homeLineupStats = [GameStatsDto]()
    
    @Published var awayLineup = FantasyLineupDto.mock
    @Published var awayLineupStats = [GameStatsDto]()
    
    @Published var earliestGameThisWeek = GameSchedule.mock
    
    
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
            
            homeLineupStats = try await fetchLineupStats(lineup: homeLineup)
                .filter({ gameStats in
                    gameStats.game.week == fantasyGame.week
                })
            
            awayLineupStats = try await fetchLineupStats(lineup: awayLineup)
                .filter({ gameStats in
                    gameStats.game.week == fantasyGame.week
                })
            
            earliestGameThisWeek = try await fetchEarliestGameInWeek()
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
        
        // TODO: Create a set fantasy lineup view by week
        
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
            .eq("week", value: Int(fantasyGame.week))
            .eq("season", value: season)
            .single()
            .execute()
            .value
    }
    
    private func fetchLineupStats(lineup: FantasyLineupDto) async throws -> [GameStatsDto] {
        LoggingManager
            .logInfo("Fetching lineup stats")
        
        return try await supabase
            .from("GameStats")
            .select("""
                player:Player!GameStats_player_id_season_fkey(*),
                game:GameSchedule!GameStats_game_id_fkey(*),
                season,
                passing_completions,
                passing_attempts,
                passing_yds,
                passing_td,
                passing_int,
                rushing_carries,
                rushing_yds,
                rushing_td,
                receiving_recs,
                receiving_yds,
                receiving_td,
                punt_returns,
                punt_return_yds,
                punt_return_td,
                kick_returns,
                kick_return_yds,
                kick_return_td,
                punting_in_20,
                kicking_xp_made,
                kicking_xp_miss,
                kicking_fg_made,
                kicking_fg_miss,
                fumbles_lost
                """)
            .in("player_id", values: lineup.playerIds)
            .eq("season", value: season)
            .execute()
            .value
    }
    
    private func fetchEarliestGameInWeek() async throws -> GameSchedule {
        let games: [GameSchedule] = try await supabase
            .from("GameSchedule")
            .select()
            .eq("season", value: season)
            .eq("week", value: Int(fantasyGame.week))
            .execute()
            .value
        
        let earliestGame = games.min { game1, game2 in
            game1.startDate! < game2.startDate!
        }
        
        return earliestGame!
    }
    
    public func addPlayerToLineupPressed(player: Player, position: String) async {
        LoggingManager
            .logInfo("Add Player to Lineup button pressed")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            showAddPlayerToLineupSheet = true
        } catch {
            let errorMsg = "Error adding player to lineup"
            LoggingManager
                .logError(errorMsg + "\(error)")
            
            alertMessage = errorMsg
            showAlert = true
        }
    }
    
    private func addPlayerToLineup(player: Player, position: String) async throws {
        LoggingManager
            .logInfo("Adding player to lineup")
        
        try await supabase
            .from("FantasyLineup")
            .update([
                "\(position.lowercased())_id" : player.id
            ])
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("league_id", value: fantasyGame.fantasyLeague.id)
            .eq("season", value: season)
            .execute()
    }
}

extension FantasyGameViewModel {
    func passingYards(for player: Player?) -> String {
        guard let player = player else { return "—" }
        
        // Search both home and away stats
        if let stats = (homeLineupStats + awayLineupStats).first(where: { $0.player.id == player.id }) {
            return "\(stats.passingYds)"
        }
        return "0"
    }
}
