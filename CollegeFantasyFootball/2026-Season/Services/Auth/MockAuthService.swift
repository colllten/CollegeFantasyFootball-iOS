//
//  MockAuthService.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import Foundation
import Supabase

// TODO: Run local Supabase
final class MockAuthService: AuthServiceProtocol {
    private let mockSession = Session(
        accessToken: "",
        tokenType: "",
        expiresIn: .nan,
        expiresAt: .nan,
        refreshToken: "",
        user: Auth.User(id: UUID(),
                        appMetadata: [:],
                        userMetadata: [:],
                        aud: "",
                        createdAt: .now,
                        updatedAt: .now))
    func signIn(email: String, password: String) async throws -> Session {
        return mockSession
    }

    func signOut() async throws { }
    
    func forgotPassword(email: String) async throws { }
}
