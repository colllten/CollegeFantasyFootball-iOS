//
//  SignUpViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/11/25.
//

import Foundation
import Supabase

class SignUpViewModel: BaseViewModel {
    @Published var emailText = "tester99@gmail.com"
    @Published var usernameText: String = "tester99"
    @Published var passwordText = "tester99"
    @Published var confirmPasswordText = "tester99"
    
    private let USERNAME_MIN_LEN: UInt8 = 3
    private let USERNAME_MAX_LEN: UInt8 = 31
    
    /// Sends sign up request to auth provider to create user
    public func attemptSignUp() async -> Bool {
        LoggingManager
            .logInfo("Attempting to sign up user with email \(self.emailText)")
        
        isLoading = true
        usernameText = usernameText.trimmingCharacters(in: .whitespacesAndNewlines)
        emailText = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let formHasValidInputs = await validateUserInputs()
        if (!formHasValidInputs) {
            isLoading = false
            return false
        }
        
        do {
            let id = try await signUp()
            try await addUserToDatabase(id: id)
            
            return true
        } catch let error as AuthError {
            handleAuthError(error)
        } catch {
            handleError(error)
        }
        
        isLoading = false
        return false
    }
    
    private func signUp() async throws -> UUID {
        LoggingManager
            .logInfo("Submitting sign up data")
        
        let session = try await supabase
            .auth
            .signUp(
                email: emailText,
                password: passwordText,
                data: ["username" : .string(usernameText)])
        return session.user.id
    }
    
    private func addUserToDatabase(id: UUID) async throws {
        LoggingManager
            .logInfo("Adding user \(self.usernameText) to database")
        
        try await supabase
            .from("User")
            .insert([
                "id" : id.uuidString,
                "username" : self.usernameText
            ])
            .execute()
    }
    
    private func handleAuthError(_ error: AuthError) {
        LoggingManager
            .logError("AuthError occurred while signing up: \(error)")
        
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
            .logError("Error occurred while signing up: \(error)")
        
        alertMessage = "Error occurred while signing up. Please try again"
        showAlert = true
    }
    
    /// Checks all fields are valid before sending to auth provider
    private func validateUserInputs() async -> Bool {
        LoggingManager
            .logInfo("Validating form inputs")
        
        if !emailMatchesRegEx() {
            LoggingManager
                .logWarning("Invalid email: \(emailText)")
            
            alertMessage = "Invalid email"
            showAlert = true
            return false
        } else if !usernameIsWithinRange() {
            LoggingManager
                .logWarning("Invalid username length: \(usernameText.count)")
            
            alertMessage = "Invalid username length"
            showAlert = true
            return false
        } else if !usernameContainsOnlyAlphanumerics() {
            LoggingManager
                .logWarning("Username contains invalid characters: \(usernameText)")
            
            alertMessage = "Username contains invalid characters"
            showAlert = true
            return false
        } else if await !usernameIsUnique() {
            LoggingManager
                .logWarning("Username is not unique: \(usernameText)")
            
            alertMessage = "Username is already in use"
            showAlert = true
            return false
        } else if !passwordAndConfirmPasswordMatch() {
            LoggingManager
                .logWarning("Passwords do not match")
            
            alertMessage = "Passwords do not match"
            showAlert = true
            return false
        }
        
        return true
    }
    
    /// Validates an email is valid to be sent to DB
    private func emailMatchesRegEx() -> Bool {
        LoggingManager
            .logInfo("Comparing email to regex format")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: emailText)
    }
    
    /// Checks if given username is within length range
    private func usernameIsWithinRange() -> Bool {
        LoggingManager
            .logInfo("Checking if username is within length")
        
        return (usernameText.count >= USERNAME_MIN_LEN) &&
               (usernameText.count <= USERNAME_MAX_LEN)
    }
    
    /// Checks if a given username contains alphanumeric characters only
    /// WARNING: A reasonable length must be known before calling this function
    private func usernameContainsOnlyAlphanumerics() -> Bool {
        LoggingManager
            .logInfo("Checking if username contains only alphanumeric characters")
        let alphaNumRegEx = "[A-Z0-9a-z]+"
        let alphaNumPred = NSPredicate(format:"SELF MATCHES %@", alphaNumRegEx)
        
        return alphaNumPred.evaluate(with: usernameText)
    }
    
    /// Checks if username is unique by calling database to ensure username is not in use
    private func usernameIsUnique() async -> Bool {
        LoggingManager
            .logInfo("Checking if username is unique")
        do {
            let data: [[String : String]] = try await supabase
                .from("User")
                .select("username")
                .eq("username", value: usernameText)
                .execute()
                .value
            
            return data.count == 0
        } catch {
            LoggingManager
                .logError("Error fetching usernames: \(error)")
            return false
        }
    }
    
    /// Checks if ``passwordText`` and ``confirmPasswordText`` match
    private func passwordAndConfirmPasswordMatch() -> Bool {
        LoggingManager
            .logInfo("Checking if passwords match")
        return passwordText == confirmPasswordText
    }
}
