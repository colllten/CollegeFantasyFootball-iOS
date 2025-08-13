//
//  NewDraftViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/11/25.
//

import Foundation
import Supabase

class NewDraftViewModel: BaseViewModel {
    @Published var draftPicks: [NewDraftPick] = []
    let fantasyLeague: FantasyLeague
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for NewDraftView")
        
        isLoading = true
        
        do {
            draftPicks = try await fetchDraftPicks()
            
            try await subscribeToRealtime()
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            
            alertMessage = "Error loading data"
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchDraftPicks() async throws -> [NewDraftPick] {
        LoggingManager
            .logInfo("Fetching draft picks")
        
        return try await supabase
            .from("DraftPicks")
            .select("""
                league_id,
                user_id,
                round,
                pick,
                player_id,
                season,
                player:Player!DraftPicks_player_id_season_fkey(*)
                """)
            .eq("league_id", value: fantasyLeague.id)
            .eq("season", value: season)
            .execute()
            .value
    }
    
    private func subscribeToRealtime() async throws {
        LoggingManager
            .logInfo("Subscribing to realtime in NewDraftView")
        let channel = supabase
            .channel("draft-\(fantasyLeague.id)")
        
        let updates = channel.postgresChange(
            UpdateAction.self,
            schema: "public",
            table: "DraftPicks"
        )
        
        try await channel.subscribeWithError()
        
        for await update in updates {
            if let pick = update.record["pick"]?.intValue,
               let playerId = update.record["player_id"]?.intValue,
               pick - 1 < draftPicks.count {
                LoggingManager
                    .logInfo("\(playerId) drafted")
                
                if let index = draftPicks.firstIndex(where: { $0.playerId == nil }) {
                    draftPicks[index].playerId = playerId
                    draftPicks[index].player = try await supabase
                        .from("Player")
                        .select()
                        .eq("id", value: playerId)
                        .eq("season", value: season)
                        .single()
                        .execute()
                        .value
                }
            }
        }
    }
    
    public func unsubscribeToRealtime() async {
        LoggingManager
            .logInfo("Unsubscribing to realtime in NewDraftView")
        
        await supabase
            .realtimeV2
            .channel("draft-\(fantasyLeague.id)")
            .unsubscribe()
    }
}

struct NewDraftPick: Codable, Identifiable {
    let id = UUID() // Required for Identifiable
    
    let leagueId: UUID
    let userId: UUID
    let round: Int
    let pick: Int
    
    let season: Int
    var playerId: Int?
    var player: Player?
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case userId = "user_id"
        case round = "round"
        case pick = "pick"
        case season = "season"
        case playerId = "player_id"
        case player = "player"
    }
}
