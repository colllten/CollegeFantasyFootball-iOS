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
    
    func signUp(email: String, password: String, username: String) async throws -> AuthResponse {
        LoggingManager
            .logInfo("Signing up user")
        
        return try await supabase
            .auth
            .signUp(email: email,
                    password: password,
                    data: ["username" : .string(username)])
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
    
    func deleteAccount() async throws {
        let userId = currentUserId!
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: sessionKey)
        let session = supabase.auth.currentSession
        try await supabase
            .from("User")
            .delete()
            .eq("id", value: userId)
            .execute()
        
        // Delete the user from the database first
        try await deleteWithEdge(session: session)
        
        // After successful deletion, sign out locally to clear the session
        try await supabase.auth.signOut()
        
        // Clear any local user data
        currentUser = nil
    }

    private func deleteWithEdge(session: Session?) async throws {
        let accessToken = session?.accessToken ?? ""
        
        print("Debug: Access token length: \(accessToken.count)")
        print("Debug: Access token preview: \(String(accessToken.prefix(20)))...")
        
        // 1. Edge Function URL
        let url = URL(string: "https://hebkomjefcdetcamnnpa.supabase.co/functions/v1/delete-user")!
        
        // 3. Build the request with Bearer token
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [:])
        
        print("Debug: Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // 4. Call the Edge Function
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Debug: HTTP Status: \(httpResponse.statusCode)")
            print("Debug: Response data: \(errorMessage)")
            throw NSError(domain: "EdgeFunctionError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        LoggingManager.logInfo("User deleted successfully: \(String(data: data, encoding: .utf8) ?? "")")
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
