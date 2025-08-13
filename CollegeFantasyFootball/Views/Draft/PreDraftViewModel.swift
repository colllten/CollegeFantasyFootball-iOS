//
//  PreDraftViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/21/25.
//

import Foundation
import Supabase
import SwiftUI
import EventKit

class PreDraftViewModel: BaseViewModel {
    @Published var fantasyLeague: FantasyLeague
    @Published var showDraftView = false
        
    var userIsLeagueOwner: Bool {
        let userId = AuthManager.shared.currentUser!.id
        return userId.uuidString.lowercased() == fantasyLeague.ownerId.lowercased()
    }
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func subscribeToRealtimeDraftStatus() async {
        LoggingManager
            .logInfo("Subscribing to realtime draft status")
        
        do {
            try await trySubscribeRealtimeDraftStatus()
        } catch {
            LoggingManager
                .logError("Error subscribing to realtime draft status: \(error)")
            
            alertMessage = "Error connecting to fantasy league. Please try again"
            showAlert = true
        }
    }
    
    public func unsubscribeToRealtime() async {
        LoggingManager
            .logInfo("Unsubscribing from realtime draft status")
        
        let channel = supabase
            .realtimeV2
            .channel("draft-status")
        
        await supabase
            .realtimeV2
            .removeChannel(channel)
    }
    
    public func startDraftPressed() async {
        LoggingManager
            .logInfo("Start draft button pressed \(fantasyLeague.id.uuidString)")
        
        isLoading = true
        do {
            try await startDraft()
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showDraftView = true
        } catch {
            LoggingManager
                .logError("Error starting draft: \(error)")
            alertMessage = "Error starting draft. Please try again"
            showAlert = true
        }
        isLoading = false
    }
    
    public func addDraftToCalendar(date: Date,
                                   title: String = "Fantasy Football Draft") {
        LoggingManager
            .logInfo("Adding draft to calendar")
        let eventStore = EKEventStore()
        
        // Request access to the calendar
        eventStore.requestWriteOnlyAccessToEvents { granted, error in
            guard granted, error == nil else {
                // TODO: Add alert message for denial of access
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = date
            event.endDate = date.addingTimeInterval(60 * 60) // 1 hour duration
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                self.alertMessage = "Draft added to calendar!"
                self.showAlert = true
                
            } catch {
                LoggingManager
                    .logError("Error adding to calendar: \(error)")
            }
        }
    }

    
    private func startDraft() async throws {
        LoggingManager
            .logInfo("Updating draft in progress")
        
        try await supabase
            .from("FantasyLeague")
            .update(["draft_in_progress" : true])
            .eq("id", value: fantasyLeague.id)
            .execute()
    }
    
    private func trySubscribeRealtimeDraftStatus() async throws {
        let channel = supabase.channel("draft-status")
        let updates = channel
            .postgresChange(
                UpdateAction.self,
                schema: "public",
                table: "FantasyLeague"
            )
        
        await channel.subscribe()
        
        for await update in updates {
            if validateFantasyLeagueDraftStarted(update: update) {
                try await waitUntilDraftPicksAvailable()
                
                showDraftView = true
            }
        }
    }
    
    private func validateFantasyLeagueDraftStarted(update: UpdateAction) -> Bool {
        if let changedRecordId = update.oldRecord["id"]?.stringValue {
            if changedRecordId == fantasyLeague.id.uuidString.lowercased() {
                return update.record["draft_in_progress"]?.boolValue ?? false
            }
        }
        return false
    }
    
    private func waitUntilDraftPicksAvailable() async throws {
        var attempts = 0
        while attempts < 10 {
            let picks: [DraftViewModel.DraftPicksResponse] = try await supabase
                .from("DraftPicks")
                .select("league_id, user_id, round, pick, player_id, User!inner(username)")
                .eq("league_id", value: fantasyLeague.id.uuidString)
                .execute()
                .value
            
            if !picks.isEmpty { return }
            
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
            attempts += 1
        }
        throw NSError(domain: "Timeout waiting for draft picks", code: 0)
    }

}
