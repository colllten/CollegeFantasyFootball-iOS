//
//  SignUpView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/11/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm = SignUpViewModel()
    
    @FocusState private var focusedField: Field?
    @State private var showFields = false

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                CustomTextField(placeholder: "Username", text: $vm.usernameText)
                    .keyboardType(.alphabet)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .email
                    }
                    .focused($focusedField, equals: .username)
                
                CustomTextField(placeholder: "Email", text: $vm.emailText)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .focused($focusedField, equals: .email)
                
                SecureCustomTextField(placeholder: "Password", text: $vm.passwordText)
                    .textContentType(.newPassword)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .confirmPassword
                    }
                    .focused($focusedField, equals: .password)
                
                SecureCustomTextField(placeholder: "Confirm Password", text: $vm.confirmPasswordText)
                    .textContentType(.password)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .confirmPassword)
                
                signUpButton
                Spacer()
            }
            .offset(y: showFields ? 0 : -900)
            .opacity(showFields ? 1 : 0)
            .padding(.vertical)
            .textInputAutocapitalization(.never)
            .onAppear {
                withAnimation(.spring(response: 1.3, dampingFraction: 1, blendDuration: 0.5)) {
                    showFields = true
                }
            }
            .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
            
            Spacer()
        }
        .padding()
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                let signUpSuccess = await vm.attemptSignUp()
                if signUpSuccess {
                    dismiss()
                }
            }
        } label: {
            Text("Submit")
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .foregroundStyle(.white)
                .background(Color(.systemBlue))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

extension SignUpView {
    private enum Field: Int, CaseIterable {
        case username
        case email
        case password
        case confirmPassword
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
