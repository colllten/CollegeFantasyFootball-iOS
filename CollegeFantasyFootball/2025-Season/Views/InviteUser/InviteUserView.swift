//
//  InviteUserView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/14/25.
//

import SwiftUI

struct InviteUserView: View {
    @State private var focusView = InviteUserViewFocus.search
    @ObservedObject var vm: InviteUserViewModel
    
    var body: some View {
        TabView(selection: $focusView) {
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                searchUsersTab
            }
            
            Tab("Members", systemImage: "person.3.fill", value: .members) {
                membersTab
            }
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .task{
            await vm.loadData()
        }
    }
    
    var searchUsersTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Search Field at the top
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search by username", text: $vm.searchText)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await vm.trySearchUsername()
                        }
                    }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top)
            
            if vm.usernames.isEmpty {
                Text("No users found.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                Spacer()
            } else {
                searchResults
            }
            
            Button {
                Task {
                    await vm.trySearchUsername()
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Search")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    var membersTab: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if vm.fantasyLeagueInvites.isEmpty {
                    Text("No members have been invited yet.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(vm.fantasyLeagueInvites, id: \.receiverId) { invite in
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text(invite.receiverUsername.username)
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            
                            if let accepted = invite.accepted {
                                Image(systemName: accepted ? "checkmark.circle.fill" : "clock.fill")
                                    .foregroundColor(accepted ? .green : .orange)
                            } else {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
    }
    
    var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.usernames, id: \.id) { user in
                    HStack {
                        Text(user.username)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.inviteButtonPressed(id: user.id)
                            }
                        } label: {
                            Text("Invite")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .padding(.leading)
                }
            }
        }
    }
    
    enum InviteUserViewFocus: String {
        case search
        case members
    }
}

#Preview {
    NavigationStack {
        InviteUserView(vm: InviteUserViewModel(fantasyLeague: FantasyLeague.mock))
    }
}
