//
//  RosterViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/20/25.
//

import Foundation

class RosterViewModel: BaseViewModel {
    var fantasyLeague: FantasyLeague
    @Published var roster: FantasyRosterDto = FantasyRosterDto.emptyFantasyRosterDto
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for RosterView")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            roster = try await fetchFantasyRosterDto()
        } catch {
            let errorMsg = "Error loading data"
            LoggingManager
                .logError(errorMsg + "\(error)")
            
            alertMessage = errorMsg
            showAlert = true
        }
    }
    
    public func sortPlayersByPosition(p1: Player, p2: Player) -> Bool {
        Player.positionOrder[p1.position] ?? Int.max < Player.positionOrder[p2.position] ?? Int.max
    }
    
    private func fetchFantasyRosterDto() async throws -> FantasyRosterDto {
        LoggingManager
            .logInfo("Fetching fantasy roster DTO")
        
        return try await supabase
            .from("FantasyRoster")
            .select("""
                fantasy_league:FantasyLeague!FantasyRoster_league_id_fkey(*),
                user:User!FantasyRoster_user_id_fkey(*),
                season,
                player_1:Player!FantasyRoster_player_1_id_season_fkey(*),
                player_2:Player!FantasyRoster_player_2_id_season_fkey(*),
                player_3:Player!FantasyRoster_player_3_id_season_fkey(*),
                player_4:Player!FantasyRoster_player_4_id_season_fkey(*),
                player_5:Player!FantasyRoster_player_5_id_season_fkey(*),
                player_6:Player!FantasyRoster_player_6_id_season_fkey(*),
                player_7:Player!FantasyRoster_player_7_id_season_fkey(*),
                player_8:Player!FantasyRoster_player_8_id_season_fkey(*),
                player_9:Player!FantasyRoster_player_9_id_season_fkey(*),
                player_10:Player!FantasyRoster_player_10_id_season_fkey(*),
                player_11:Player!FantasyRoster_player_11_id_season_fkey(*),
                player_12:Player!FantasyRoster_player_12_id_season_fkey(*)
                """)
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("season", value: season)
            .single()
            .execute()
            .value
    }
    
    public func dropPlayerPressed(playerId: Int) async {
        LoggingManager
            .logInfo("Drop player pressed")
        
        isLoading = true
        defer { isLoading = false}
        
        do {
            try await dropPlayer(playerId: playerId)
            // TODO: Remove from any future rosters
            await loadData()
        } catch {
            LoggingManager
                .logError("Error dropping player: \(error)")
            alertMessage = "Error dropping player"
            showAlert = true
        }
    }
    
    private func dropPlayer(playerId: Int) async throws {
        LoggingManager
            .logInfo("Dropping player")
        
        try await removePlayerFromRoster(playerId: playerId)
        try await updateDbRoster()
    }
    
    private func removePlayerFromRoster(playerId: Int) async throws {
        if let p = roster.player1,
           p.id == playerId {
            roster.player1 = nil
        } else if let p = roster.player2,
                  p.id == playerId {
            roster.player2 = nil
        } else if let p = roster.player3,
                  p.id == playerId {
            roster.player3 = nil
        } else if let p = roster.player4,
                  p.id == playerId {
            roster.player4 = nil
        } else if let p = roster.player5,
                  p.id == playerId {
            roster.player5 = nil
        } else if let p = roster.player6,
                  p.id == playerId {
            roster.player6 = nil
        } else if let p = roster.player7,
                  p.id == playerId {
            roster.player7 = nil
        } else if let p = roster.player8,
                  p.id == playerId {
            roster.player8 = nil
        } else if let p = roster.player9,
                  p.id == playerId {
            roster.player9 = nil
        } else if let p = roster.player10,
                  p.id == playerId {
            roster.player10 = nil
        } else if let p = roster.player11,
                  p.id == playerId {
            roster.player11 = nil
        } else if let p = roster.player12,
                  p.id == playerId {
            roster.player12 = nil
        }
    }
    
    private func updateDbRoster() async throws {
        try await supabase
            .from("FantasyRoster")
            .update(
                ["player_1_id" : roster.player1?.id,
                 "player_2_id" : roster.player2?.id,
                 "player_3_id" : roster.player3?.id,
                 "player_4_id" : roster.player4?.id,
                 "player_5_id" : roster.player5?.id,
                 "player_6_id" : roster.player6?.id,
                 "player_7_id" : roster.player7?.id,
                 "player_8_id" : roster.player8?.id,
                 "player_9_id" : roster.player9?.id,
                 "player_10_id" : roster.player10?.id,
                 "player_11_id" : roster.player11?.id,
                 "player_12_id" : roster.player12?.id,
                ]
            )
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("season", value: season)
            .execute()
    }
    
    
    public func getPlayerImageUrl(playerId: Int) -> URL? {
        do {
            return try supabase
                .storage
                .from("player-headshots")
                .getPublicURL(path: "\(playerId).png")
        } catch {
            LoggingManager
                .logError("Error getting URL for player \(playerId)")
        }
        return nil
    }
}
