//
//  ProfileViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/12/25.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    @Published var user = User.mock
    @Published var issueText = ""
    let ISSUE_TEXT_MAX_LEN = 1024
    let ISSUE_TEXT_MIN_LEN = 10
    
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
    
    public func submitIssuePressed() async {
        LoggingManager
            .logInfo("Submit Issue pressed")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            cleanInput()
            try isValidInput()
            
            try await submitIssue()
            
            issueText = ""
            alertMessage = "Issue submitted"
            showAlert = true
        } catch {
            LoggingManager
                .logError("Error submitting issue: \(error)")
            alertMessage = "Error submitting issue"
            showAlert = true
        }
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
    
    private func cleanInput() {
        issueText = issueText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func isValidInput() throws {
        if issueText.count < ISSUE_TEXT_MIN_LEN {
            throw SendIssueError.UNDER_MIN_LEN
        }
        if issueText.count > ISSUE_TEXT_MAX_LEN {
            throw SendIssueError.OVER_MAX_LEN
        }
    }
    
    private func submitIssue() async throws {
        LoggingManager
            .logInfo("Submitting issue")
        
        let logStrs = LoggingManager.getLogs().map { log in
            log.message
        }
        
        let issue = Issue(
            id: UUID(),
            userId: AuthManager.shared.currentUserId!,
            issueText: issueText + "; LOGS: \(logStrs)")
        
        try await supabase
            .from("Issue")
            .insert(issue)
            .execute()
    }
    
    enum SendIssueError: Error {
        case UNDER_MIN_LEN
        case OVER_MAX_LEN
    }
}
