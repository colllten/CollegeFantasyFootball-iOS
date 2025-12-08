import Foundation
import Supabase

@Observable
final class SessionManager {
    private let supabase: SupabaseClient
    private let logger: LoggingProtocol
    
    var session: Session?
    var isLoading = true
    
    init(supabase: SupabaseClient, logger: LoggingProtocol) {
        self.supabase = supabase
        self.logger = logger
        
        Task {
            await loadInitialSession()
            await listenForAuthChanges()
        }
    }
    
    private func loadInitialSession() async {
        logger.logInfo("Loading initial session.")
        
        do {
            let s = try await supabase.auth.session
            self.session = session
            
            logger.logDebug("Session loaded.")
        } catch {
            self.session = nil
            logger.logError("Failed to load session: \(error)")
        }
        
        isLoading = false
    }
    
    private func listenForAuthChanges() async {
        await supabase
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
