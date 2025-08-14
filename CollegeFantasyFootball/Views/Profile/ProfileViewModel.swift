//
//  ProfileViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/12/25.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    @Published var user = User.mock
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for ProfileView")
        
        isLoading = true
        do {
            user = try await fetchUserData()
        } catch {
            LoggingManager
                .logError("Error loading data for ProfileView: \(error)")
            
            alertMessage = "Error loading data"
            showAlert = true
        }
        isLoading = false
    }
    
    public func signOutButtonPressed() async -> Bool {
        LoggingManager
            .logInfo("Signing \(user.id) out")
        
        await AuthManager.shared.signOut()
        return true
    }
    
    public func deleteAccountButtonPressed() async -> Bool {
        LoggingManager
            .logInfo("Deleting account \(user.id)")
        
        do {
            try await AuthManager.shared.deleteAccount()
            return true
        } catch {
            LoggingManager
                .logError("Error deleting account: \(error)")
            alertMessage = "Error deleting account. Please reach out to the developers."
            showAlert = true
        }
        return false
    }
    
    private func fetchUserData() async throws -> User {
        LoggingManager
            .logInfo("Fetching user data")
        
        return try await supabase
            .from("User")
            .select()
            .eq("id", value: AuthManager.shared.currentUserId!)
            .single()
            .execute()
            .value
    }
}
