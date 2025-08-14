//
//  ProfileView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/12/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                if let firstName = vm.user.firstName,
                   let lastName = vm.user.lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Text("@\(vm.user.username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            signOutButton
                .padding(.top, 8)
            
            deleteAccountButton
                .padding(.top, 8)
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadData()
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
    }
    
    private var signOutButton: some View {
        Button {
            Task {
                let signOutSuccess = await vm.signOutButtonPressed()
                if signOutSuccess {
                    dismiss()
                }
            }
        } label: {
            Text("Sign Out")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
    private var deleteAccountButton: some View {
        Button {
            Task {
                let success = await vm.deleteAccountButtonPressed()
                if success {
                    dismiss()
                }
            }
        } label: {
            Text("Delete Account")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(vm: ProfileViewModel())
    }
}
