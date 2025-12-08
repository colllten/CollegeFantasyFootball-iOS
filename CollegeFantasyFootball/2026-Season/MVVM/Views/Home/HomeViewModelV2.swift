import FactoryKit
import Foundation
import Supabase

@Observable
final class HomeViewModelV2: BaseViewModelV2 {
    private var sessionManager = Container.shared.sessionManager()
    private var auth = Container.shared.authService()
    private var logger = Container.shared.logger()
    
    var session: Session
    
    init (session: Session) {
        self.session = session
    }
    
    
    public func signOutButtonTapped() async {
        logger.logDebug("Sign out button tapped.")
        
        do {
            try await auth.signOut()
            sessionManager.session = nil
            
            alertMessage = "Signed out"
            showAlert = true
                        
            logger.logInfo("Signed out.")
        } catch {
            logger.logError("Error signing out: \(error)")
            alertMessage = "Error"
            showAlert = true
            return
        }
    }
}
