import FactoryKit
import Foundation

// TODO: Custom SMTP server
@Observable
final class ForgotPasswordViewModel: BaseViewModelV2 {
    private let auth = Container.shared.authService()
    
    var emailText: String = ""
    var showConfirmCodeTextField = false
    var confirmedCode: String = ""
    
    
    private func cleanEmail() {
        emailText = emailText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
