//
//  MockAuthService.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import Foundation
import Supabase

// TODO: Run local Supabase and connect to it

final class MockAuthService: AuthServiceProtocol {
    private let client = SupabaseClient(supabaseURL: URL(string: Secrets.SUPABASE_URL)!,
                                        supabaseKey: Secrets.SUPABASE_KEY)
    
    func signIn(email: String, password: String) async throws -> Session {
        return try await client
            .auth
            .signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await client
            .auth
            .signOut()
    }
}
