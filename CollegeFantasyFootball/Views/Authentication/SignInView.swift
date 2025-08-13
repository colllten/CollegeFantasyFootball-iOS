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
            
            AnimatedHeader(text: "Welcome", offset: vm.positionOffset)
            
            LoginForm
                .opacity(vm.opacity)
                .padding(.horizontal, 30)
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                Text("Rookies tap here")
                    .padding()
            }
            .opacity(vm.opacity)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            withAnimation(.none) {
                vm.positionOffset = 40
                vm.opacity = 0
            }
            vm.animateEntrance() // plays up + fade-in
        }
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

// MARK: - Animated Header Subview

struct AnimatedHeader: View {
    let text: String
    let offset: CGFloat
    
    var body: some View {
        Text(text)
            .font(.largeTitle.bold())
            .offset(y: offset) // no implicit .animation here
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

// MARK: - ViewModel Animation Helper

extension SignInViewModel {
    func animateEntrance() {
        withAnimation(.easeInOut(duration: 1)) {
            positionOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.2)) {
                self.opacity = 1
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SignInView(vm: SignInViewModel())
    }
}
