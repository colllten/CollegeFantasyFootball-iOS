//
//  SignInViewModelV2.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import Foundation
import Supabase

@Observable
final class SignInViewModelV2 {
    private let authService: AuthServiceProtocol
    
    var username: String = ""
    var password: String = ""
    
    var alertTitle: String = ""
    var showingAlert: Bool = false
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public func signInButtonTapped() async {
        // TODO: Add logging
        
        do {
            try await authService.signIn(email: username,
                                         password: password)
            print("this hit")
            alertTitle = "Success"
            showingAlert = true
        } catch let error as AuthError {
            handleSignInAuthError(error: error)
            showingAlert = true
        } catch {
            print(error)
            alertTitle = "Error"
            showingAlert = true
            return
        }
    }
    
    public func signOutButtonTapped() async {
        // TODO: Add logging
        
        do {
            try await authService.signOut()
            alertTitle = "Signed out"
            showingAlert = true
        } catch {
            print(error)
            alertTitle = "Error"
            showingAlert = true
            return
        }
    }
    
    private func handleSignInAuthError(error: AuthError) {
        print(error)
        alertTitle = switch error.errorCode {
        case .invalidCredentials, .validationFailed: "Invalid credentials"
        case .emailAddressNotAuthorized: "Email address not authorized"
        case .emailNotConfirmed: "Email not confirmed"
        case .requestTimeout: "Request timed out"
        case .userBanned: "User has been banned"
        case .userNotFound: "User not found"
        default:
            // TODO: Log and send error
            "Unknown error occurred"
        }
    }
}
