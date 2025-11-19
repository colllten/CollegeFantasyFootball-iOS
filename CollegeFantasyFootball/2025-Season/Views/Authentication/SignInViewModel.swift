//
//  SignInViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import Supabase
import SwiftUI

class SignInViewModel: BaseViewModel {
    @Published var emailText = ""
    @Published var passwordText = ""
    
    @Published var positionOffset: CGFloat = 100
    @Published var opacity: Double = 0
    
    public func submitLogin() async {
        LoggingManager
            .logInfo("Submitting email-password login for email \(self.emailText)")
        
        isLoading = true
        defer {isLoading = false}
        do {
            cleanInputs()
            try await AuthManager
                .shared
                .signIn(email: emailText, password: passwordText)
            
            LoggingManager.logInfo("Successful login")
        } catch let err as AuthError {
            await MainActor.run {
                setAlertMessage(authError: err)
                showAlert = true
            }
        } catch {
            await MainActor.run {
                setAlertMessage(error: error)
                showAlert = true
            }
        }

    }
    
    private func attemptLogin() async throws -> Session {
        return try await supabase
            .auth
            .signIn(
                email: emailText,
                password: passwordText)
    }
    
    private func cleanInputs() {
        emailText = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func setAlertMessage(authError: AuthError) {
        LoggingManager
            .logError("Error logging in with email \(self.emailText). AuthError: \(authError)")
        
        alertMessage = switch authError.errorCode {
        case .validationFailed,
                .invalidCredentials: "Invalid email and/or password"
        case .identityNotFound,
                .userNotFound: "No account exists with provided email"
        case .overRequestRateLimit: "Please wait 30 seconds to submit another login attempt"
        case .requestTimeout: "Login request expired. Please try again"
        case .unexpectedFailure,
                .unknown: fallthrough
        default: "Unknown error occurred. Please try again"
        }
        
        // Debug logging
            print("Debug: Alert message set to: \(alertMessage)")
            print("Debug: showAlert will be set to true")
    }
    
    private func setAlertMessage(error: Error) {
        LoggingManager
            .logError("Error logging in with email \(self.emailText)")
        
        alertMessage = "Unexpected error occurred while logging in. Please try again"
    }
}
