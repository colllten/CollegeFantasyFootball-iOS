//
//  AuthManager.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/9/25.
//

import SwiftUI
import Supabase
import Combine

@MainActor
class AuthManager: BaseViewModel {
    static let shared = AuthManager()
    
    @Published var currentUser: Auth.User? = nil
    var currentUserId: UUID? {
        currentUser?.id
    }
    
    private let userIdKey = "userId"
    private let sessionKey = "supabase_session"
    
    @Published var isLoadingSession: Bool = true
    
    public func loadSession() async {
        LoggingManager
            .logInfo("Loading session on app startup")
        
        isLoadingSession = true
        defer { isLoadingSession = false }
        
        guard let data = UserDefaults.standard.data(forKey: sessionKey),
              let session = try? JSONDecoder().decode(Session.self, from: data) else {
            LoggingManager
                .logWarning("Previous session could not be found, or session could not be decoded")
            currentUser = nil
            return
        }
        
        do {
            // Restore into Supabase Auth
            try await supabase.auth.setSession(accessToken: session.accessToken,
                                               refreshToken: session.refreshToken)
            currentUser = supabase.auth.currentUser
            await refreshSession()
        } catch {
            LoggingManager
                .logInfo("Failed to restore session: \(error)")
            currentUser = nil
            
            alertMessage = "Error restoring your session"
            showAlert = true
        }
        isLoadingSession = false
    }
    
    /// Signs in the user with Supabase email/password
    func signIn(email: String, password: String) async throws {
        LoggingManager
            .logInfo("Signing in")
        
        isLoading = true
        defer { isLoading = false }
        
        let session = try await supabase
            .auth
            .signIn(email: email, password: password)
        
        // Save session to storage
        if let encoded = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(encoded, forKey: sessionKey)
        }
        
        currentUser = session.user
    }
    
    /// Signs the user out
    func signOut() async {
        LoggingManager
            .logInfo("Signing out")
        do {
            try await supabase.auth.signOut()
        } catch {
            LoggingManager
                .logInfo("Sign out failed: \(error)")
        }
        
        UserDefaults.standard.removeObject(forKey: sessionKey)
        currentUser = nil
    }
    
    /// Refresh session token if needed
    func refreshSession() async {
        LoggingManager
            .logInfo("Refreshing session")
        do {
            let session = try await supabase.auth.refreshSession()
            if let encoded = try? JSONEncoder().encode(session) {
                UserDefaults.standard.set(encoded, forKey: sessionKey)
            }
            currentUser = session.user
        } catch {
            LoggingManager
                .logError("Session refresh failed: \(error)")
            currentUser = nil
        }
    }
}
