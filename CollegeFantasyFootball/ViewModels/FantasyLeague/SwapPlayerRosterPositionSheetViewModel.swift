//
//  SwapPlayerRosterPositionSheetViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/19/25.
//

import Foundation
import SwiftUI

final class SwapPlayerRosterPositionSheetViewModel: BaseViewModel {
    var fantasyLeague: FantasyLeague
    var selectedPlayerPostion: String
    var selectedPlayer: Player?
    var rosterPlayers: RosterPlayers
    
    init(fantasyLeague: FantasyLeague, selectedPlayerPosition: String, selectedPlayer: Player?, rosterPlayers: RosterPlayers) {
        self.fantasyLeague = fantasyLeague
        self.selectedPlayer = selectedPlayer
        self.selectedPlayerPostion = selectedPlayerPosition
        self.rosterPlayers = rosterPlayers
    }
    
    public func trySwapPlayerRosterPositions(
        sourceRosterPosition: String,
        sourcePlayer: Player?,
        destinationRosterPosition: String,
        destinationPlayer: Player?
    ) async {
        LoggingManager
            .logInfo("Swapping \(sourceRosterPosition) to \(destinationRosterPosition) with roster: \(rosterPlayers)")
        
        isLoading = true
        do {
            try await swapPlayerRosterPositions(
                sourceRosterPosition: sourceRosterPosition,
                sourcePlayer: sourcePlayer,
                destinationRosterPosition: destinationRosterPosition,
                destinationPlayer: destinationPlayer
            )
        } catch {
            LoggingManager
                .logError("Error swapping players: \(error)")
            
            alertMessage = "Error swapping players"
            showAlert = true
        }
        isLoading = false
    }
    
    private func swapPlayerRosterPositions(
        sourceRosterPosition: String,
        sourcePlayer: Player?,
        destinationRosterPosition: String,
        destinationPlayer: Player?
    ) async throws {
        try await supabase
            .from("Roster")
            .update([
                sourceRosterPosition : destinationPlayer?.id,
                destinationRosterPosition : sourcePlayer?.id
            ])
            .eq("league_id", value: fantasyLeague.id)
            .execute()
    }
}
