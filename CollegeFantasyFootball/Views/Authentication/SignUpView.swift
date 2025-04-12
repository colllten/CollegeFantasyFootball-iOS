//
//  SignUpView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/11/25.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var vm = SignUpViewModel()
    /// Tracks which field is active; used for focusing to next field
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
                    .keyboardType(.asciiCapable)
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
                
                Spacer()
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
//        .navigationDestination(isPresented: $vm.signUpSuccessful) {
//            Text("hello")
//                .navigationBarBackButtonHidden()
//        }
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                await vm.attemptSignUp()
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

/// Extension to add focus on each text field for user to navigate to next one
extension SignUpView {
    private enum Field: Int, CaseIterable {
        case username, email, password, confirmPassword
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .confirmPassword
        }
    }

    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .username
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }

    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}

#Preview {
    NavigationView {
        SignUpView()
    }
}
