import Foundation
import Supabase
import SwiftUI

@Observable
final class SessionManager {
    private let supabaseClient: SupabaseClient
    private let logger: LoggingProtocol
    
    var session: Session?
    
    init(supabase: SupabaseClient,
         logger: LoggingProtocol) {
        self.supabaseClient = supabase
        self.logger = logger
        
        Task {
            await loadInitialSession()
            await listenForAuthChanges()
        }
    }
    
    private func loadInitialSession() async {
        logger.logInfo("Loading initial session.")
        
        do {
            let s = try await supabaseClient.auth.session
            self.session = s
            
            logger.logDebug("Session loaded.")
        } catch {
            self.session = nil
            logger.logError("Failed to load session: \(error)")
        }
    }
    
    private func listenForAuthChanges() async {
        await supabaseClient
            .auth
            .onAuthStateChange { [weak self] event, session in
                guard let self else { return }
                
                Task { @MainActor in
                    switch event {
                    case .signedIn:
                        self.logger.logInfo("User signed in.")
                        self.session = session
                    case .signedOut:
                        self.logger.logInfo("User signed out.")
                        self.session = nil
                    default:
                        break
                    }
                }
            }
    }
}
