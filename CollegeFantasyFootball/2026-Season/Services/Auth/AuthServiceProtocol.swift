//
//  AuthServiceProtocol.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
    
    func signIn(email: String, password: String) async throws -> Session
    
    func signOut() async throws
}
