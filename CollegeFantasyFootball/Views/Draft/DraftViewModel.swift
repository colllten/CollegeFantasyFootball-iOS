//
//  DraftViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/23/25.
//

// TODO: Ensure proper filtering of players

import Foundation
import SwiftUI
import Supabase

class DraftViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    
    private var hasLoadedInitialPicks = false

    
    var positions: [String] {
        var allPositions = ["None", "QB", "RB", "WR", "TE"]
        if fantasyLeague.includeKickers {
            allPositions.append("PK")
        }
        if fantasyLeague.includePunters {
            allPositions.append("P")
        }
        // TODO: Defense
        return allPositions
    }
    @Published var positionSelection = "None"

    var schoolNames: [String] {
        var sorted = schoolIdPairs.keys.sorted()
        if let noneIndex = sorted.firstIndex(of: "None") {
            sorted.remove(at: noneIndex)
            sorted.insert("None", at: 0)
        }
        return sorted
    }
    var schoolIds: [Int] {
        idSchoolPairs.keys.sorted()
    }
    @Published var schoolSelection = "None"
    
    // All players in the listed schools
    var players: [Player] = []
    // Filtered sublist of players based on school and/or position
    var filteredPlayers: [Player] {
        var filtered = players
        
        // Filter school
        if schoolSelection != "None" {
            guard let schoolId = schoolIdPairs[schoolSelection] else { return players }
            
            filtered = filtered.filter({ player in
                player.teamId == schoolId
            })
        }
        
        // Filter position
        if positionSelection != "None" {
            filtered = filtered.filter({ player in
                player.position == positionSelection
            })
        }
        
        // Filter out drafted players
        let draftedIds = draftPicks
            .filter { draftPick in
                draftPick.playerId != nil
            }
            .map { $0.playerId! }
        
        filtered = filtered.filter({ player in
            !draftedIds.contains(player.id)
        })
        
        return filtered
    }
    
    // All draft picks in the fantasy league's draft
    @Published var draftPicks: [DraftPicksResponse] = []
    
    // Players on user's draft board
    @Published var draftBoardPlayers: [Player] = []
    
    @Published var showFantasyLeagueView = false
    
    var draftedPlayers: [Player] {
        let userId = AuthManager.shared.currentUserId!
        
        return players.filter { player in
            draftPicks.first { draftPick in
                draftPick.leagueId == fantasyLeague.id
                &&
                draftPick.playerId == player.id
                &&
                draftPick.userId.lowercased() == userId.uuidString.lowercased()
            } != nil
        }
    }
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager.logInfo("Loading data for DraftView")
        
        isLoading = true
        do {
            draftPicks = try await fetchDraftPicks().sorted { $0.pick < $1.pick }
            players = try await fetchPlayers()
            draftBoardPlayers = try await fetchDraftBoardPlayers()
            
            hasLoadedInitialPicks = true
        } catch {
            LoggingManager.logError("Error loading draft data: \(error)")
            alertMessage = "Error loading draft data"
            showAlert = true
        }
        isLoading = false
    }

    
    public func trySubscribeRealtime() async {
        LoggingManager
            .logInfo("Subscribing to DraftView realtime")
        do {
            try await subscribeToRealTime()
        } catch {
            LoggingManager
                .logError("Error subscribing to real time: \(error)")
            alertMessage = "Error loading draft"
            showAlert = true
        }
    }
    
    public func fetchImageUrl(playerId: Int) -> URL? {
        do {
            return try supabase
                .storage
                .from("player-headshots")
                .getPublicURL(path: "\(playerId).png")
        } catch {
            LoggingManager
                .logError("Error fetching headshot \(playerId)")
            return nil
        }
    }
    
    /// Fetches all players within the schools
    private func fetchPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching players for draft")
        
        let fetchedPlayers: [Player] = try await supabase
            .from("Player")
            .select()
            .in("position", values: positions)
            .in("team_id", values: schoolIds)
            .eq("season", value: season)
            .execute()
            .value
        
        return fetchedPlayers
    }
    
    /// Fetches all draft picks for a fantasy league's draft
    private func fetchDraftPicks() async throws -> [DraftPicksResponse] {
        LoggingManager
            .logInfo("Getting draft picks for league \(fantasyLeague.id)")
        
        let response: [DraftPicksResponse] = try await supabase
            .from("DraftPicks")
            .select("""
                league_id,
                user_id,
                round,
                pick,
                player_id,
                season,
                player_names:Player!DraftPicks_player_id_season_fkey(first_name, last_name),
                User!inner(username)
            """)
            .eq("league_id", value: fantasyLeague.id)
            .execute()
            .value

        return response
    }
    
    public func tryDraftPlayer(playerId: Int) async {
        LoggingManager
            .logInfo("Drafting player \(playerId)")
        
        isLoading = true
        do {
            try await draftPlayer(playerId: playerId)
            // Remove from user's draft board
            try await removeFromDraftBoard(playerId: playerId)
        } catch {
            LoggingManager
                .logError("Error drafting player \(playerId): \(error)")
            alertMessage = "Error drafting player"
            showAlert = true
        }
        isLoading = false
    }
    
    public func draftBoardFlagPressed(playerId: Int) async {
        LoggingManager
            .logInfo("Draft board flag pressed")
        
        let playerInDraftBoard = draftBoardPlayers.contains { player in
            player.id == playerId
        }
        
        isLoading = true
        if playerInDraftBoard {
            await tryRemoveFromDraftBoard(playerId: playerId)
        } else {
            await tryAddToDraftBoard(playerId: playerId)
        }
        isLoading = false
    }
    
    public func scrollToNextPick(proxy: ScrollViewProxy) {
        guard let nextPick = draftPicks.first(where: { $0.playerId == nil }) else { return }

        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(nextPick.pick, anchor: .center)
            }
        }
    }
    
    private func tryAddToDraftBoard(playerId: Int) async {
        LoggingManager
            .logInfo("Adding player \(playerId) to draft board")
        
        isLoading = true
        do {
            try await addToDraftBoard(playerId: playerId)
            
            guard let player = players.first(where: { player in
                player.id == playerId
            }) else
            {
                return
            }
            draftBoardPlayers.append(player)
        } catch {
            LoggingManager
                .logError("Error adding player \(playerId) to draft board: \(error)")
            alertMessage = "Error adding player to draft board"
            showAlert = true
        }
        isLoading = false
    }
    
    private func tryRemoveFromDraftBoard(playerId: Int) async {
        LoggingManager
            .logInfo("Removing player \(playerId) from draft board")
        
        do {
            try await removeFromDraftBoard(playerId: playerId)
        } catch {
            LoggingManager
                .logError("Error removing player \(playerId) from draft board: \(error)")
            
            alertMessage = "Error removing player from draft board"
            showAlert = true
        }
    }
    
    private func removeFromDraftBoard(playerId: Int) async throws {
        let userId = AuthManager.shared.currentUserId!
        
        try await supabase
            .from("DraftBoard")
            .delete(returning: .minimal)
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: userId)
            .eq("player_id", value: playerId)
            .eq("season", value: season)
            .execute()
        
        draftBoardPlayers.removeAll { player in
            player.id == playerId
        }
    }
    
    private func fetchDraftBoardPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Loading draft board")
        
        let userId = AuthManager.shared.currentUserId!
        
        let playerIdDict: [[String : Int]] = try await supabase
            .from("DraftBoard")
            .select("player_id")
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: userId)
            .execute()
            .value
        
        let playerIds = playerIdDict.map({ row in
            guard let playerId = row["player_id"] else { return 0 }
            return playerId
        })
        
        let playersOnDraftBoard: [Player] = try await supabase
            .from("Player")
            .select()
            .in("id", values: playerIds)
            .eq("season", value: season)
            .execute()
            .value
        
        return playersOnDraftBoard
    }
    
    private func addToDraftBoard(playerId: Int) async throws {
        let userId = AuthManager.shared.currentUserId!
        
        let draftBoard = DraftBoard(
            leagueId: fantasyLeague.id,
            userId: userId,
            playerId: playerId,
            season: season)
        
        try await supabase
            .from("DraftBoard")
            .insert(draftBoard)
            .execute()
    }
    
    private func draftPlayer(playerId: Int) async throws {
        guard let draftPick = draftPicks.first(where: { pick in
            pick.playerId == nil
        }) else {
            return
        }
        
        let userId = AuthManager.shared.currentUserId!.uuidString
        if userId.lowercased() != draftPick.userId.lowercased() {
            alertMessage = "It is not your turn to draft"
            showAlert = true
            return
        }
        
        try await supabase
            .from("DraftPicks")
            .update(["player_id" : playerId])
            .eq("league_id", value: fantasyLeague.id)
            .eq("round", value: Int(draftPick.round))
            .eq("pick", value: Int(draftPick.pick))
            .eq("season", value: season)
            .execute()
    }
    
    private func subscribeToRealTime() async throws {
        let channel = supabase
            .channel("draft-\(fantasyLeague.id)")
        
        let updates = channel.postgresChange(
            UpdateAction.self,
            schema: "public",
            table: "DraftPicks"
        )
        
        try await channel.subscribeWithError()
        
        for await update in updates {
            // Prevent updates from applying before draftPicks are loaded
            guard hasLoadedInitialPicks else { continue }
            
            if !validatePlayerDraftedInLeague(update: update) {
                continue
            }

            if let pick = update.record["pick"]?.intValue,
               let playerId = update.record["player_id"]?.intValue,
               pick - 1 < draftPicks.count {
                draftPicks[pick - 1].playerId = playerId
                
                // Also update playerNames if needed
                    if let player = players.first(where: { $0.id == playerId }) {
                        draftPicks[pick - 1].playerNames = .init(
                            firstName: player.firstName,
                            lastName: player.lastName
                        )
                    } else {
                        // If player not in local players list, fetch from Supabase
                        Task {
                            let fetched: Player = try await supabase
                                .from("Player")
                                .select("first_name,last_name")
                                .eq("id", value: playerId)
                                .eq("season", value: season)
                                .single()
                                .execute()
                                .value
                            
                            await MainActor.run {
                                draftPicks[pick - 1].playerNames = .init(
                                    firstName: fetched.firstName,
                                    lastName: fetched.lastName
                                )
                            }
                        }
                    }
                
                if draftBoardPlayers.contains(where: { player in
                    player.id == playerId
                }) {
                    try await removeFromDraftBoard(playerId: playerId)
                }
            }
            
            guard let lastPick = draftPicks.last else { return }
            if lastPick.playerId != nil {
                alertMessage = "Draft has ended"
                showAlert = true
                showFantasyLeagueView = true
            }
        }

    }
    
    public func unsubscribeFromRealtime() async {
        LoggingManager
            .logInfo("Unsubscribing from realtime in DraftView")
        let channel = supabase
            .realtimeV2
            .channel("draft-\(fantasyLeague.id)")
        
        await supabase
            .realtimeV2
            .channel("draft-\(fantasyLeague.id)")
            .unsubscribe()
    }
    
    private func validatePlayerDraftedInLeague(update: UpdateAction) -> Bool {
        LoggingManager
            .logInfo("Validating player was drafted in league")
        
        guard let leagueId = update.oldRecord["league_id"]?.stringValue else {
            return false
        }
        
        return leagueId.lowercased() == fantasyLeague.id.uuidString.lowercased()
    }
    
    struct DraftPicksResponse: Decodable, Equatable {
        let id = UUID()
        let leagueId: UUID
        let userId: String
        let round: UInt8
        let pick: UInt16
        let season: Int
        var playerId: Int?
        var playerNames: PlayerNames?
        let user: User
        
        struct PlayerNames: Codable, Equatable {
            let firstName: String
            let lastName: String
            
            private enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case lastName = "last_name"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case leagueId = "league_id"
            case userId = "user_id"
            case round = "round"
            case pick = "pick"
            case season = "season"
            case playerId = "player_id"
            case playerNames = "player_names"
            case user = "User"
        }
    }
    
    struct TeamsResponse: Decodable {
        let id: Int
        let school: String
    }
    
    struct User: Decodable, Equatable {
        let username: String
        
        private enum CodingKeys: String, CodingKey {
            case username = "username"
        }
    }
}
