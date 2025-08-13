//
//  CreateFantasyLeageSheetModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/8/25.
//

import Foundation

class CreateFantasyLeageSheetViewModel: BaseViewModel {
    @Published var dismiss: Bool = false
    @Published var fantasyLeague = FantasyLeague.newLeague
    
    public func tryCreateFantasyLeague() async {
        LoggingManager
            .logInfo("Trying to create fantasy league")
        
        isLoading = true
        do {
            cleanInputs()
            try await validateFantasyLeagueSettings()
            
            fantasyLeague.ownerId = AuthManager
                .shared
                .currentUser!
                .id
                .uuidString
            
            try await addFantasyLeagueToDb()
            try await addOwnerLeagueRelationToDb()
            
            dismiss = true
        } catch is CreateFantasyLeagueError {
            LoggingManager
                .logWarning("Error creating fantasy league: " + alertMessage)
            showAlert = true
        } catch {
            LoggingManager
                .logError("Error creating fantasy league: \(error)")
            
            alertMessage = "Error creating fantasy league"
            showAlert = true
        }
        isLoading = false
    }
    
    private func cleanInputs() {
        fantasyLeague.leagueName = fantasyLeague.leagueName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func validateFantasyLeagueSettings() async throws {
        if fantasyLeague.leagueName.isEmpty {
            alertMessage = "Please enter a fantasy league name"
            throw CreateFantasyLeagueError.emptyLeagueName
        }
        
        if fantasyLeague.leagueName.count < 3 {
            alertMessage = "Fantasy league name must be greater than 2 characters"
            throw CreateFantasyLeagueError.invalidLeagueNameLength
        }
        
        if !isValidDraftDate() {
            alertMessage = "Draft date must either be today or a future date"
            throw CreateFantasyLeagueError.invalidDraftDate
        }
        
        if try await !fantasyLeagueNameIsUnique() {
            alertMessage = "Fantasy league name already in use"
            throw CreateFantasyLeagueError.leagueNameInUse
        }
    }
    
    private func isValidDraftDate() -> Bool {
        let calendar = Calendar.current
        
        if calendar.isDate(fantasyLeague.draftDate, inSameDayAs: .now) {
            return true
        }
        
        let draftDate = calendar.startOfDay(for: fantasyLeague.draftDate)
        let startOfToday = calendar.startOfDay(for: .now)
        
        return draftDate > startOfToday
    }


    
    private func addFantasyLeagueToDb() async throws {
        LoggingManager
            .logInfo("Adding fantasy league to database")
        
        try await supabase
            .from("FantasyLeague")
            .insert(fantasyLeague)
            .execute()
    }
    
    private func addOwnerLeagueRelationToDb() async throws {
        let userId = AuthManager.shared.currentUserId!
        LoggingManager
            .logInfo("Adding user \(userId) to league \(fantasyLeague.id)")
        
        let leagueUser = FantasyLeagueUser(
            fantasyLeagueId: fantasyLeague.id,
            userId: userId)
        
        try await supabase
            .from("FantasyLeagueUser")
            .insert(leagueUser)
            .execute()
    }
    
    private func fantasyLeagueNameIsUnique() async throws -> Bool {
        LoggingManager
            .logInfo("Checking if fantasy league name is unique")
        
        let data = try await supabase
            .from("FantasyLeague")
            .select(count: .exact)
            .eq("league_name", value: fantasyLeague.leagueName)
            .execute()
            .count ?? 0
        
        return data == 0
    }
    
    private enum CreateFantasyLeagueError: Error {
        case emptyLeagueName
        case invalidLeagueNameLength
        case invalidDraftDate
        case leagueNameInUse
    }
}
