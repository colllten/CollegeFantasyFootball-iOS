//
//  DraftViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/30/25.
//


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
        schoolIdPairs.keys.sorted()
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
        
        return players
    }
    
    // All draft picks in the fantasy league's draft
    @Published var draftPicks: [DraftPicksResponse] = []
    
    // Players on user's draft board
    @Published var draftBoardPlayers: [Player] = []
    
    @Published var showFantasyLeagueView = false
    
    var draftedPlayers: [Player] {
        let userId = UserDefaults
            .standard
            .string(forKey: "userId") ?? "13aeb04a-398e-4092-920e-df5dce1bc96b"
        
        return players.filter { player in
            draftPicks.first { draftPick in
                draftPick.leagueId == fantasyLeague.id
                &&
                draftPick.playerId == player.id
                &&
                draftPick.userId.lowercased() == userId.lowercased()
            } != nil
        }
    }
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager.logInfo("Loading data for draft")
        
        isLoading = true
        do {
            draftPicks = try await fetchDraftPicks().sorted { $0.pick < $1.pick }
            players = try await fetchPlayers()
//            filteredPlayers = players
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
    
    /// Fetches all players within the schools
    private func fetchPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching players for draft")
        
        let fetchedPlayers: [Player] = try await supabase
            .from("Player")
            .select()
            .in("team_id", values: schoolIds)
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
            .select("league_id, user_id, round, pick, player_id, User!inner(username)")
            .eq("league_id", value: fantasyLeague.id.uuidString)
            .execute()
            .value
        return response
    }
    
//    public func filterPlayers() {
//        LoggingManager
//            .logInfo("Filtering players... schoolSelection=\(schoolSelection), positionSelection=\(positionSelection)")
//        if schoolSelection == "None" || positionSelection == "None" {
//            filteredPlayers = players.filter({ player in
//                !draftedPlayers.contains {
//                    $0.id == player.id
//                }
//            })
//        }
//        
//        if schoolSelection != "None" {
//            let schoolId = schoolIdPairs[schoolSelection]
//            
//            filteredPlayers = players.filter {
//                $0.teamId == schoolId
//            }
//            
//            if positionSelection != "None" {
//                filteredPlayers = filteredPlayers.filter({ player in
//                    player.position == positionSelection
//                })
//            }
//        } else if positionSelection != "None" {
//            filteredPlayers = filteredPlayers.filter({ player in
//                player.position == positionSelection
//            })
//        }
//    }
    
    public func tryDraftPlayer(playerId: Int) async {
        LoggingManager
            .logInfo("Drafting player \(playerId)")
        
        isLoading = true
        do {
            try await draftPlayer(playerId: playerId)
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
        let userId = UserDefaults
            .standard
            .string(forKey: "userId") ?? "13aeb04a-398e-4092-920e-df5dce1bc96b"
        
        try await supabase
            .from("DraftBoard")
            .delete(returning: .minimal)
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: userId)
            .eq("player_id", value: playerId)
            .execute()
        
        draftBoardPlayers.removeAll { player in
            player.id == playerId
        }
    }
    
    private func fetchDraftBoardPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Loading draft board")
        
        let userId = UserDefaults
            .standard
            .string(forKey: "userId") ?? "13aeb04a-398e-4092-920e-df5dce1bc96b"
        
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
            .execute()
            .value
        
        return playersOnDraftBoard
    }
    
    private func addToDraftBoard(playerId: Int) async throws {
        let userId = UserDefaults
            .standard
            .string(forKey: "userId") ?? "13aeb04a-398e-4092-920e-df5dce1bc96b"
        
        let draftBoard = DraftBoard(
            leagueId: fantasyLeague.id,
            userId: UUID(uuidString: userId)!,
            playerId: playerId)
        
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
        
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "13aeb04a-398e-4092-920e-df5dce1bc96b"
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
            .execute()
        
        draftedPlayers
    }
    
    private func endDraft() async throws {
        try await supabase
            .from("FantasyLeague")
            .update([
                "draft_in_progress" : false,
                "draft_complete" : true
            ])
            .eq("id", value: fantasyLeague.id)
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
        
        await channel.subscribe()
        
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
            }
            
            guard let lastPick = draftPicks.last else { return }
            if lastPick.playerId != nil {
                try await endDraft()
                alertMessage = "Draft has ended"
                showAlert = true
                showFantasyLeagueView = true
            }
        }

    }
    
    public func unsubscribeFromRealtime() async {
        LoggingManager
            .logInfo("Unsubscribing from DraftView realtime")
        let channel = supabase
            .realtimeV2
            .channel("draft-\(fantasyLeague.id)")
        
        await supabase
            .realtimeV2
            .removeChannel(channel)
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
        var playerId: Int?
        let user: User
        
        private enum CodingKeys: String, CodingKey {
            case leagueId = "league_id"
            case userId = "user_id"
            case round = "round"
            case pick = "pick"
            case playerId = "player_id"
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