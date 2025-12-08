import Foundation
import FactoryKit
import Supabase

extension Container {
    var logger: Factory<LoggingProtocol> {
        self {
            LoggingService()
        }
        .singleton
    }
    
    var supabaseClient: Factory<SupabaseClient> {
        self {
            SupabaseClient(supabaseURL: URL(string: AppConfig.supabaseURL)!,
                           supabaseKey: AppConfig.supabaseKey)
        }.singleton
    }
    
    var sessionManager: Factory<SessionManager> {
        self {
            SessionManager(supabase: self.supabaseClient(),
                           logger: self.logger())
        }.singleton
    }
    
    var authService: Factory<AuthServiceProtocol> {
        self {
            AuthService(client: self.supabaseClient())
        }
    }
}
