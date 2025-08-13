//
//  NewRecruitsViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation
import PostgREST

final class NewRecruitsViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    
    @Published var allPlayers: [Player] = []
    @Published var rosteredPlayers: [Player] = []
    @Published var searchStr: String = ""
    var availablePlayers: [Player] {
        let rosteredPlayersIds = rosteredPlayers.map { $0.id }
        
        var filteredPlayers = allPlayers.filter { player in
            !rosteredPlayersIds.contains(player.id)
        }
        
        if positionSelection != "None" {
            filteredPlayers = filteredPlayers.filter {
                $0.position == positionSelection
            }
        }
        
        if schoolSelection != "None" {
            filteredPlayers = filteredPlayers.filter {
                schoolIdPairs[schoolSelection] == $0.teamId
            }
        }
        
        if searchStr != "" {
            filteredPlayers = filteredPlayers.filter({ player in
                player.firstName.lowercased().contains(searchStr.lowercased())
                ||
                player.lastName.lowercased().contains(searchStr.lowercased())
                ||
                player.fullName.lowercased().contains(searchStr.lowercased())
            })
        }
        
        return filteredPlayers.sorted { p1, p2 in
            p1.fullName < p2.fullName
        }
    }
    
    var positions: [String] {
        var basePositions = ["None", "QB", "RB", "TE", "WR"]
        
        if fantasyLeague.includePunters { basePositions.append("P") }
        if fantasyLeague.includeKickers { basePositions.append("PK") }
        return basePositions
    }
    @Published var positionSelection = "None"
    
    let schools: [String] = ["None"] + Array(schoolIdPairs.keys).sorted()
    @Published var schoolSelection = "None"
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for RecruitsView")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            allPlayers = try await fetchAllPlayers()
            rosteredPlayers = try await fetchRosteredPlayers()
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            alertMessage = "Error loading data"
            showAlert = true
        }
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
    
    public func recruitButtonPressed(player: Player) async {
        LoggingManager
            .logInfo("Recruit button pressed")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await recruitPlayer(player)
        } catch let error as UpdateRosterError {
            switch error {
            case .NO_AVAILABLE_ROSTER_SPOT:
                alertMessage = "No available roster spots. Drop a player before recruiting another."
            case .PLAYER_NOT_AVAILABLE:
                alertMessage = "Player is no longer available"
            }
            showAlert = true
        } catch {
            LoggingManager
                .logError("Error recruiting player \(player.id): \(error)")
            alertMessage = "Error recruiting player"
            showAlert = true
        }
    }
    
    private func recruitPlayer(_ player: Player) async throws {
        LoggingManager
            .logInfo("Recruiting player \(player.id)")
        var currentUserRoster = try await fetchCurrentUserRoster()
        
        let latestRosteredPlayers = try await fetchRosteredPlayers()
        let latestRosteredPlayerIds = latestRosteredPlayers.map { $0.id }
        
        if latestRosteredPlayerIds.contains(player.id) {
            rosteredPlayers.append(player)
            throw UpdateRosterError.PLAYER_NOT_AVAILABLE
        }
        
        let addedToRoster = currentUserRoster.assignToFirstEmptySlot(player)
        if !addedToRoster {
            throw UpdateRosterError.NO_AVAILABLE_ROSTER_SPOT
        }
        
        rosteredPlayers.append(player)
        try await updateCurrentUserRosterInDb(currentUserRoster)
    }
    
    private func fetchCurrentUserRoster() async throws -> FantasyRosterDto {
        LoggingManager
            .logInfo("Fetching current user's roster in fantasy league \(fantasyLeague.id)")
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
    
    private func updateCurrentUserRosterInDb(_ roster: FantasyRosterDto) async throws {
        LoggingManager
            .logInfo("Updating the current user's roster in fantasy league \(fantasyLeague.id)")
        
        try await supabase
            .from("FantasyRoster")
            .update([
                "player_1_id" : roster.player1?.id,
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
                "player_12_id" : roster.player12?.id
            ])
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("season", value: season)
            .execute()
    }
    
    private func fetchAllPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching all players")
        
        return try await supabase
            .from("Player")
            .select()
            .in("position", values: positions)
            .eq("season", value: season)
            .execute()
            .value
    }
    
    private func fetchRosteredPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching FantasyRosters in fantasy league \(fantasyLeague.id)")
        
        let response: PostgrestResponse<[FantasyRosterDto]> = try await supabase
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
            .eq("season", value: season)
            .execute()
        let rosters = response.value
        var rosteredPlayers: [Player] = []
        for roster in rosters {
            rosteredPlayers.append(contentsOf: roster.rosterPlayers)
        }
                              
        return rosteredPlayers
    }
}
