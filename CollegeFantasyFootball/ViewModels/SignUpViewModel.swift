//
//  SignUpViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/11/25.
//

import Foundation
import Supabase

class SignUpViewModel: BaseViewModel {
    @Published var emailText = ""
    @Published var usernameText: String = ""
    @Published var passwordText = ""
    @Published var confirmPasswordText = ""
    /// Triggers if next view should appear
    @Published var signUpSuccessful = false
    
    /// Minimum username length
    private let USERNAME_MIN_LEN: UInt8 = 3
    /// Maximum username length
    private let USERNAME_MAX_LEN: UInt8 = 31
    
    /// Sends sign up request to auth provider to create user
    public func attemptSignUp() async {
        LoggingManager
            .general
            .info("Attempting to sign up user with email \(self.emailText)")
        previewPrint("Attempting to sign up user with email \(self.emailText)")
        
        isLoading = true
        
        let formHasValidInputs = await validateUserInputs()
        if (!formHasValidInputs) {
            isLoading = false
            return
        }
        
        do {
            try await signUp()
            try await addUserToTable()
            signUpSuccessful = true
        } catch let error as AuthError {
            handleAuthError(error)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func signUp() async throws {
        LoggingManager
            .general
            .info("Submitting sign up data")
        
        let session = try await supabase
            .auth
            .signUp(
                email: emailText,
                password: passwordText,
                data: ["username" : .string(usernameText)])
        
        setUserId(session.user.id)
        previewPrint("successful sign up for \(emailText)")
    }
    
    private func addUserToTable() async throws {
        LoggingManager
            .general
            .info("Adding user \(self.usernameText) to table")
        
        try await supabase
            .from("User")
            .insert([
                "id" : UserDefaults.standard.string(forKey: "userId"),
                "username" : self.usernameText
            ])
            .execute()
    }
    
    private func setUserId(_ id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: "userId")
    }
    
    private func handleAuthError(_ error: AuthError) {
        LoggingManager
            .general
            .error("AuthError occurred while signing up: \(error)")
        previewPrint("AuthError occurred while signing up: \(error)")
        
        alertMessage = switch (error.errorCode) {
        case .emailExists, .userAlreadyExists:
            "User with email already exists"
        case .weakPassword:
            "Weak password, please try a new one"
        case .unexpectedFailure, .unknown:
            fallthrough
        default:
            "Unexpected error occurred, please try again"
        }
        
        showAlert = true
    }
    
    private func handleError(_ error: Error) {
        LoggingManager
            .general
            .error("Error occurred while signing up: \(error)")
        previewPrint("Error occurred while signing up: \(error)")
        
        alertMessage = "Error occurred while signing up. Please try again"
        showAlert = true
    }
    
    /// Checks all fields are valid before sending to auth provider
    private func validateUserInputs() async -> Bool {
        if !emailMatchesRegEx() {
            alertMessage = "Invalid email"
            showAlert = true
            return false
        } else if !usernameIsWithinRange() {
            alertMessage = "Invalid username length"
            showAlert = true
            return false
        } else if !usernameContainsOnlyAlphanumerics() {
            alertMessage = "Username contains invalid characters"
            showAlert = true
            return false
        } else if await !usernameIsUnique() {
            alertMessage = "Username is already in use"
            showAlert = true
            return false
        } else if !passwordAndConfirmPasswordMatch() {
            alertMessage = "Passwords do not match"
            showAlert = true
            return false
        }
        
        return true
    }
    
    /// Validates an email is valid to be sent to DB
    private func emailMatchesRegEx() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: emailText)
    }
    
    /// Checks if given username is within length range
    private func usernameIsWithinRange() -> Bool {
        return (usernameText.count >= USERNAME_MIN_LEN) &&
               (usernameText.count <= USERNAME_MAX_LEN)
    }
    
    /// Checks if a given username contains alphanumeric characters only
    /// WARNING: A reasonable length must be known before calling this function
    private func usernameContainsOnlyAlphanumerics() -> Bool {
        let alphaNumRegEx = "[A-Z0-9a-z]+"
        let alphaNumPred = NSPredicate(format:"SELF MATCHES %@", alphaNumRegEx)
        
        return alphaNumPred.evaluate(with: usernameText)
    }
    
    /// Checks if username is unique by calling database to ensure username is not in use
    private func usernameIsUnique() async -> Bool {
        do {
            let data: [[String : String]] = try await supabase
                .from("User")
                .select("username")
                .eq("username", value: usernameText)
                .execute()
                .value
            
            return data.count == 0
        } catch {
            LoggingManager.general.error("Error fetching usernames: \(error)")
            print(error)
            return false
        }
    }
    
    /// Checks if ``passwordText`` and ``confirmPasswordText`` match
    private func passwordAndConfirmPasswordMatch() -> Bool {
        return passwordText == confirmPasswordText
    }
}
