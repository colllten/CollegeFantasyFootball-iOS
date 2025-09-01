//
//  OtpSignInViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 9/1/25.
//

import Foundation
import Supabase

final class OtpSignInViewModel: BaseViewModel {
    @Published var emailText = ""
    @Published var showEnterOtp = false
    @Published var otpText = ""
    @Published var dismiss = false
    
    public func submitOtpPressed() async {
        LoggingManager
            .logInfo("Submit OTP pressed")
        
        do {
            emailText = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
            try await submitOtpRequest()
            showEnterOtp = true
        } catch let error as AuthError {
            switch error.errorCode {
            case .otpDisabled:
                let alertMsg = "Email not registered"
                LoggingManager
                    .logWarning(alertMsg + ": \(error)")
                
                alertMessage = alertMsg
                showAlert = true
            case .overEmailSendRateLimit:
                let alertMsg = "You can only send one OTP request per minute"
                LoggingManager
                    .logWarning(alertMsg + ": \(error)")
                
                alertMessage = alertMsg
                showAlert = true
            default:
                let alertMsg = "Error submitting OTP request"
                LoggingManager
                    .logError(alertMsg + ": \(error)")
                
                alertMessage = alertMsg
                showAlert = true
            }
        } catch {
            let alertMsg = "Error submitting OTP request"
            LoggingManager
                .logError(alertMsg + ": \(error)")
            
            alertMessage = alertMsg
            showAlert = true
        }
    }
    
    public func verifyOtpPressed() async {
        LoggingManager
            .logInfo("Verify OTP pressed")
        
        do {
            otpText = otpText.trimmingCharacters(in: .whitespacesAndNewlines)
            let authResponse = try await submitVerifyOtp()
            
            if let encoded = try? JSONEncoder().encode(authResponse.session) {
                UserDefaults.standard.set(encoded, forKey: "supabase_session")
            }
            await AuthManager.shared.loadSession()
            print("Success")
            
            await MainActor.run {
                self.dismiss = true
            }
            
            // TODO: Check case for email that does not exist
        } catch {
            let alertMsg = "Error verifying OTP"
            LoggingManager
                .logError(alertMsg + ": \(error)")
            
            alertMessage = alertMsg
            showAlert = true
        }
    }
    
    private func submitOtpRequest() async throws {
        LoggingManager
            .logInfo("Submitting OTP request")
        
        try await supabase
            .auth
            .signInWithOTP(email: emailText,
                           shouldCreateUser: false)
    }
    
    private func submitVerifyOtp() async throws -> AuthResponse {
        try await supabase
            .auth
            .verifyOTP(email: emailText,
                       token: otpText,
                       type: .email)
    }
}
