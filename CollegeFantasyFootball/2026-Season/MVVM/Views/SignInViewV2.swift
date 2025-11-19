//
//  SignInViewV2.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/9/25.
//

import SwiftUI
import Supabase // TODO: Remove

struct SignInViewV2: View {
    @State private var vm: SignInViewModelV2
    
    init(vm: SignInViewModelV2) {
        self.vm = vm
    }
    
    var body: some View {
        Form {
            TextField("Username", text: $vm.username)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            TextField("Password", text: $vm.password)
            Button("Sign In") {
                Task {
                    await vm.signInButtonTapped()
                }
            }
            
            Button("Sign Out") {
                Task {
                    await vm.signOutButtonTapped()
                }
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showingAlert) {
            
        }
    }
}

#Preview {
    let client = SupabaseClient(supabaseURL: URL(string: Secrets.SUPABASE_URL)!,
                                        supabaseKey: Secrets.SUPABASE_KEY)
    let authService = AuthService(client: client)
    
    let vm = SignInViewModelV2(authService: authService)
    
    SignInViewV2(vm: vm)
}
