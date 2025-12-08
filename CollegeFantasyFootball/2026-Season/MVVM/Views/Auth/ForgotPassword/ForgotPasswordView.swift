import SwiftUI

// TODO: Custom SMTP server
struct ForgotPasswordView: View {
    @State private var vm = ForgotPasswordViewModel()
    
    var body: some View {
        Form {
            Section("Please enter your email") {
                TextField("", text: $vm.emailText)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            if vm.showConfirmCodeTextField {
                Section("Enter the code you received") {
                    TextField("", text: $vm.confirmedCode)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                }
            }
            
            Button("Submit") {
                
            }
        }
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
