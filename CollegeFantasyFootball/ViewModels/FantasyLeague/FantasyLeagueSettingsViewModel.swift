//
//  FantasyLeagueSettingsViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/16/25.
//

import Foundation

public class FantasyLeagueSettingsViewModel: BaseViewModel {
    @Published var fantasyLeague: FantasyLeague
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func saveSettings() async {
        LoggingManager
            .logInfo("Saving fantasy league settings")
        
        isLoading = true
        do {
            if !isDraftDateOnOrAfterToday(fantasyLeague.draftDate) {
                throw ChangeSettingsError.InvalidDraftDate
            }
            try await supabase
                .from("FantasyLeague")
                .update(fantasyLeague)
                .eq("id", value: fantasyLeague.id.uuidString)
                .execute()
            
            alertMessage = "Saved settings"
            showAlert = true
        } catch is ChangeSettingsError {
            LoggingManager
                .logError("Invalid draft date")
            
            alertMessage = "Invalid draft date"
            showAlert = true
        } catch {
            LoggingManager
                .logError("Unexpected error occurred while saving fantasy league settings: \(error)")
            alertMessage = "Unexpected error occurred"
            showAlert = true
        }
        
        isLoading = false
    }
    
    private func isDraftDateOnOrAfterToday(_ draftDate: Date) -> Bool {
        return draftDate >= fantasyLeague.draftDate
    }
    
    enum ChangeSettingsError: Error {
        case InvalidDraftDate
    }
}


