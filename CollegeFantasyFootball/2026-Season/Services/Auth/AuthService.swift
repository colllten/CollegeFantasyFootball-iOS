//
//  AuthService.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import Foundation
import Supabase

public class AuthService: AuthServiceProtocol {
    private let client: SupabaseClient
    
    public init(client: SupabaseClient) {
        self.client = client
    }
    
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
