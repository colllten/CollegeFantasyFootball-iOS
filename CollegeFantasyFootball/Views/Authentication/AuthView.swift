//
//  AuthView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import SwiftUI
import Supabase

final class AuthViewModel: BaseViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var loading = false
    
    @Published var resultEmail = ""
    
    func signInButtonTapped() {
        Task {
            loading = true
            defer { loading = false }
            
            do {
                var session = try await supabase
                    .auth
                    .signIn(
                        email: email,
                        password: password)
                
                if let email = session.user.email {
                    resultEmail = email
                }
//                result = .success(())
            } catch {
                print(error)
//                result = .failure(error)
            }
        }
    }
}

struct AuthView: View {
    @ObservedObject private var vm = AuthViewModel()
    @State var result: Result<Void, Error>?
    
    var body: some View {
        Form {
            Section {
                TextField("Email", text: $vm.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Section {
                SecureField("Password", text: $vm.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Section {
                TextField("Result Email", text: $vm.resultEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Section {
                Button("Sign in") {
                    vm.signInButtonTapped()
                }
                
                if vm.loading {
                    ProgressView()
                }
            }
            
            if let result {
                Section {
                    switch result {
                    case .success:
                        Text("Check your inbox.")
                    case .failure(let error):
                        Text(error.localizedDescription).foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
