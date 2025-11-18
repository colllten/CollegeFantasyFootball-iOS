//
//  NotificationsView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/21/25.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var vm: NotificationsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if vm.unansweredLeagueInvites.isEmpty {
                    Text("You have no league invites.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(vm.unansweredLeagueInvites) { invite in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("League: \(invite.leagueName.leagueName)")
                                .font(.headline)
                            
                            Text("Invited by: \(invite.senderUsername.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                declineInviteButton(senderId: invite.senderId, leagueId: invite.leagueId)
                                Spacer()
                                acceptInviteButton(senderId: invite.senderId, leagueId: invite.leagueId)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("League Invites")
        .task {
            await vm.loadData()
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }

    
    private func acceptInviteButton(senderId: UUID, leagueId: UUID) -> some View {
        Button {
            Task {
                await vm.acceptButtonPressed(senderId: senderId, leagueId: leagueId)
            }
        } label: {
            Text("Accept")
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private func declineInviteButton(senderId: UUID, leagueId: UUID) -> some View {
        Button(role: .destructive) {
            Task {
                await vm.declineButtonPressed(senderId: senderId, leagueId: leagueId)
            }
        } label: {
            Text("Decline")
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
        }
    }
}


#Preview {
    NavigationStack {
        NotificationsView(vm: NotificationsViewModel())
    }
}
