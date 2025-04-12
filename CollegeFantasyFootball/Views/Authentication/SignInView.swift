//
//  ContentView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm = SignInViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            headerText
            
            VStack(spacing: 16) {
                emailTextField
                passwordSecureTextField
                loginButton
            }
            .opacity(vm.opacity)
            .animation(.easeInOut(duration: 1.2), value: vm.opacity)
            .padding(.horizontal, 30)
            
            Spacer()
            
            signUpNavigationLink
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) { vm.positionOffset = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { vm.opacity = 1 }
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .navigationDestination(isPresented: $vm.successfulLogin) {
            HomeView()
        }
    }
    
    private var headerText: some View {
        Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.bold)
            .offset(y: vm.positionOffset)
            .animation(.easeInOut(duration: 2), value: vm.positionOffset)
    }
    
    private var emailTextField: some View {
        CustomTextField(placeholder: "Email", text: $vm.emailText)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
    
    private var passwordSecureTextField: some View {
        SecureCustomTextField(placeholder: "Password", text: $vm.passwordText)
            .textInputAutocapitalization(.never)
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await vm.submitLogin()
            }
        } label: {
            Text("Login")
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
        }
    }
    
    private var signUpNavigationLink: some View {
        NavigationLink {
            SignUpView()
        } label: {
            Text("Rookies tap here")
                .padding()
        }
        .opacity(vm.opacity)  // Gradual fade-in
        .animation(.easeInOut(duration: 1.2), value: vm.opacity)
    }
}

#Preview {
    NavigationView {
        SignInView()
    }
}
