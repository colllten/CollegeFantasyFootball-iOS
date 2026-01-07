import Foundation
import KeychainSwift
import LocalAuthentication
import Supabase
import FactoryKit

extension SignInViewV2 {
    @Observable
    final class ViewModel: BaseViewModelV2 {
        private let sessionManager = Container.shared.sessionManager()
        private let auth = Container.shared.authService()
        private let logger = Container.shared.logger()
        
        private let EMAIL_KEYCHAIN_KEY = "user-email"
        private let PASSWORD_KEYCHAIN_KEY = "user-password"
        
        let DEFAULT_SIGN_IN_BUTTON_TEXT = "Sign In"
        let SIGNING_IN_TEXT = "Signing in..."
        
        var email: String = ""
        var password: String = ""
        
        var isUnlocked: Bool = false
        var showForgotPassword = false
        
        var loggedInNoFaceId: Bool {
            get {
                let result = UserDefaults
                    .standard
                    .bool(forKey: UserDefaultsKeys.LOGGED_IN_NO_FACE_ID)
                
                logger.logDebug("User has logged in without Face ID: \(result).")
                
                return result
            }
            set {
                UserDefaults
                    .standard
                    .set(newValue, forKey: UserDefaultsKeys.LOGGED_IN_NO_FACE_ID)
                
                logger.logDebug("User has logged in with Face ID set to \(newValue).")
            }
        }
        
        var enableFaceId: Bool = false
        
        
        var disableSignInButton: Bool {
            return email.isEmpty || password.isEmpty
        }
        
        override init() {
            super.init()
            self.enableFaceId = UserDefaults.standard.bool(forKey: UserDefaultsKeys.ENABLE_FACE_ID)
            logger.logDebug("Loaded enableFaceId = \(enableFaceId) from UserDefaults.")
        }
        
        public func signInEmailPasswordButtonTapped() async {
            logger.logDebug("Sign in (email/password) button tapped.")
            
            updateEnableFaceIdUserDefaults(newValue: enableFaceId)
            
            cleanEmail()
            
            do {
                sessionManager.session = try await signIn()
                setKeychainLogin()
                email = ""
                password = ""
                loggedInNoFaceId = true
            } catch let error as AuthError {
                logger.logWarning("Auth error occurred: \(error)")
                handleSignInAuthError(error: error)
                showAlert = true
            } catch {
                logger.logWarning("Unknown auth error occurred: \(error)")
                alertMessage = "Error"
                showAlert = true
                return
            }
        }
        
        public func signInFaceIdTapped() async {
            logger.logDebug("Sign in with Face ID tapped.")
            
            if !enableFaceId {
                alertMessage = "Face ID not enabled"
                showAlert = true
                return
            }
            
            if !loggedInNoFaceId {
                alertMessage = "You must have signed in with Face ID enabled at least once before signing in using Face ID"
                showAlert = true
                return
            }
            
            updateEnableFaceIdUserDefaults(newValue: enableFaceId)
            
            autofillWithFaceId()
            
            do {
                sessionManager.session = try await signIn()
                
                logger.logInfo("Successfully signed in as \(email).")
                
                email = ""
                password = ""
            } catch let error as AuthError {
                logger.logWarning("Auth error occurred: \(error)")
                handleSignInAuthError(error: error)
                showAlert = true
            } catch {
                logger.logWarning("Unknown auth error occurred: \(error)")
                alertMessage = "Error"
                showAlert = true
            }
        }
        
        private func signIn() async throws -> Session {
            logger.logInfo("Attempting sign in.")
            
            // TODO: Remove; autofill is too slow before sign in is called
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            return try await auth.signIn(email: email,
                                         password: password)
        }
        
        private func cleanEmail() {
            email = email
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
        }
        
        private func setKeychainLogin() {
            let keychain = KeychainSwift()
            keychain.set(email, forKey: EMAIL_KEYCHAIN_KEY)
            keychain.set(password, forKey: PASSWORD_KEYCHAIN_KEY)
        }
        
        private func autofillWithFaceId() {
            logger.logDebug("Autofilling via Face ID.")
            let keychain = KeychainSwift()
            
            guard let storedEmail = keychain.get(EMAIL_KEYCHAIN_KEY),
                  let storedPassword = keychain.get(PASSWORD_KEYCHAIN_KEY) else {
                return
            }
            
            authenticate { success in
                if success {
                    DispatchQueue.main.async {
                        self.email = storedEmail
                        self.password = storedPassword
                    }
                }
            }
        }
        
        private func authenticate(completion: @escaping (Bool) -> Void) {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Face ID is used to fill sign in credentials."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    completion(success)
                }
            } else {
                completion(false)
            }
        }
        
        private func handleSignInAuthError(error: AuthError) {
            logger.logError("Error with sign in: \(error).")
            
            alertMessage = switch error.errorCode {
            case .invalidCredentials, .validationFailed: "Invalid credentials"
            case .emailAddressNotAuthorized: "Email address not authorized"
            case .emailNotConfirmed: "Email not confirmed"
            case .requestTimeout: "Request timed out"
            case .userBanned: "User has been banned"
            case .userNotFound: "User not found"
            default:
                "Unknown error occurred"
            }
        }
        
        private func updateEnableFaceIdUserDefaults(newValue: Bool) {
            UserDefaults
                .standard
                .set(newValue, forKey: UserDefaultsKeys.ENABLE_FACE_ID)
            
            logger.logDebug("Set UserDefaults key \(UserDefaultsKeys.ENABLE_FACE_ID) to \(newValue)")
        }
    }
}
