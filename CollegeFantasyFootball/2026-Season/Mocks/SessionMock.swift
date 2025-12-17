import Foundation
import Supabase

extension Session {
#if DEBUG
    static let homePreviewSession = Session(
        accessToken: "",
        tokenType: "",
        expiresIn: .infinity,
        expiresAt: .infinity,
        refreshToken: "",
        user: Auth.User(id: UUID(),
                   appMetadata: [:],
                   userMetadata: [:], aud: "",
                   createdAt: Date.now,
                   updatedAt: Date.now))
#endif
}

