//
//  SignInViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import Supabase
import SwiftUI

class SignInViewModel: BaseViewModel {
    /// Email text entered by user
    @Published var emailText = ""
    /// Password text entered by user
    @Published var passwordText = ""
    /// Flag to change view
    @Published var successfulLogin = false
    /// Starting position for views before animation
    @Published var positionOffset: CGFloat = 100
    /// Opacity of views
    @Published var opacity: Double = 0
    
    /// Submits a login attempt to Supabase
    public func submitLogin() async {
        LoggingManager
            .general
            .info("Submitting email-password login for email \(self.emailText)")
        
        isLoading = true
        
        do {
            try await attemptLogin()
            successfulLogin = true
        } catch let err as AuthError {
            handleAuthError(error: err)
        } catch {
            handleError(error: error)
        }
        
        isLoading = false
    }
    
    /// Attempts to log user in
    private func attemptLogin() async throws {
        try await supabase
            .auth
            .signIn(email: emailText, password: passwordText)
    }
    
    /// Assigns a message string to present to user
    private func handleAuthError(error: AuthError) {
        LoggingManager
            .general
            .error("Error logging in with email \(self.emailText). AuthError: \(error)")
        previewPrint("\(error)")
        
        alertMessage = switch error.errorCode {
        case .invalidCredentials: "Invalid email and/or password"
        case .identityNotFound: "No account exists with provided email"
        case .overRequestRateLimit: "Please wait 30 seconds to submit another login attempt"
        case .requestTimeout: "Login request expired. Please try again"
        case .unexpectedFailure,
                .unknown,
                .userNotFound,
                .validationFailed: fallthrough
        default: "Unknown error occurred. Please try again"
        }
        showAlert = true
    }
    
    private func handleError(error: Error) {
        LoggingManager
            .general
            .error("Error logging in with email \(self.emailText)")
        previewPrint("\(error)")
        
        alertMessage = "Unexpected error occurred while logging in. Please try again"
        showAlert = true
    }
}
