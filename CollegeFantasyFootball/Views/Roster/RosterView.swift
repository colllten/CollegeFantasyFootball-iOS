//
//  RosterView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/20/25.
//

import SwiftUI

struct RosterView: View {
    @StateObject var vm: RosterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        let filled = vm.roster.rosterPlayers.count
                        let max = 12 // TODO: Don't hardcode
                        
                        if filled < max {
                            Text("\(max - filled) roster \(max - filled == 1 ? "spot" : "spots") available")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("\(filled)/\(max) roster spots filled")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(vm.roster.rosterPlayers.sorted(by: vm.sortPlayersByPosition(p1:p2:)), id: \.id) { player in
                            RosterPlayerRowView(vm: vm,
                                                player: player,
                                                url: vm.getPlayerImageUrl(playerId: player.id))
                            .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .listRowSeparator(.hidden)
                            .padding(.horizontal)
                        }
                    }
                }
                .task { await vm.loadData() }
                .withLoading(vm.isLoading)
                .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
    }
    
    struct RosterPlayerRowView: View {
        let vm: RosterViewModel
        let player: Player
        let url: URL?
        
        var body: some View {
            HStack(spacing: 12) {
                Text("\(player.position)")
                    .font(.headline)
                    .bold()
                    .frame(minWidth: 25)
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        avatarPlaceholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    case .failure:
                        avatarPlaceholder
                    @unknown default:
                        avatarPlaceholder
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.fullName)
                        .font(.headline)
                    
                    Text("\(idSchoolPairs[player.teamId]!)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    Task {
                        await vm.dropPlayerPressed(playerId: player.id)
                    }
                } label: {
                    Text("Drop")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 2)
                }
            }
            .padding(.vertical, 6)
        }
        
        private func initials(from player: Player) -> String {
            let firstInitial = player.firstName.first.map(String.init) ?? ""
            let lastInitial = player.lastName.first.map(String.init) ?? ""
            return firstInitial + lastInitial
        }
        
        private var avatarPlaceholder: some View {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(initials(from: player))
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    RosterView()
//}
