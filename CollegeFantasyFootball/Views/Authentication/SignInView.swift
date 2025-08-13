//
//  SignInView.swift
//  CollegeFantasyFootball
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm: SignInViewModel
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
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                Text("Rookies tap here")
                    .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
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
