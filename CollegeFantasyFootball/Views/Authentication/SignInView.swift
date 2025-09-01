//
//  SignInView.swift
//  CollegeFantasyFootball
//

import SwiftUI
import Supabase

struct SignInView: View {
    @StateObject var vm = SignInViewModel()
    @FocusState var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome")
                .font(.largeTitle.bold())
            
            LoginForm
                .padding(.horizontal, 30)
                .padding(.bottom, 15)
            NavigationLink("Forgot password?") {
                OtpSignInView()
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                Text("Rookies tap here")
                    .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private var LoginForm: some View {
        VStack(spacing: 16) {
            CustomTextField(placeholder: "Email", text: $vm.emailText)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
            
            SecureCustomTextField(placeholder: "Password", text: $vm.passwordText)
                .focused($focusedField, equals: .password)
            
            Button {
                Task {
                    await vm.submitLogin()
                }
            } label: {
                Text("Login").buttonStyle()
            }
        }
        .textInputAutocapitalization(.never)
    }
}

struct OtpSignInView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = OtpSignInViewModel()
    
    
    var body: some View {
        VStack {
            Text("Enter your email")
                .font(.title)
                .bold()
            
            TextField("email", text: $vm.emailText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .disabled(vm.showEnterOtp)
                .padding()
            
            if !vm.showEnterOtp {
                Button("Submit") {
                    Task {
                        await vm.submitOtpPressed()
                    }
                }
            } else {
                VStack {
                    TextField("code", text: $vm.otpText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.oneTimeCode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .padding()
                    
                    Button("Verify") {
                        Task {
                            await vm.verifyOtpPressed()
                        }
                    }
                }
            }
        }
        .onChange(of: vm.dismiss, { _, _ in
            dismiss()
        })
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
    }
}

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
        } catch {
            let alertMsg = "Error submitting OTP"
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
// MARK: - Reusable Button Style Modifier

extension View {
    func buttonStyle(background: Color = .blue, foreground: Color = .white) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(background)
            .foregroundStyle(foreground)
            .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SignInView(vm: SignInViewModel())
    }
}
