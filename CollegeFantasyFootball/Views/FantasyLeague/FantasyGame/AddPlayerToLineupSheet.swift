//
//  AddPlayerToLineupSheet.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/27/25.
//

import SwiftUI

struct AddPlayerToLineupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddPlayerToLineupSheetViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if vm.selectablePlayers.isEmpty {
                    Text("You must sign a player at this position")
                } else {
                    ForEach(vm.selectablePlayers, id: \.id) { player in
                        AddPlayerRowView(vm: vm,
                                         player: player,
                                         url: vm.getPlayerImageUrl(playerId: player.id))
                            .padding()
                    }
                }
            }
        }
        .onChange(of: vm.dismiss) { _, _ in
            dismiss()
        }
        .task {
            await vm.loadData()
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
    }
    
    func playerRow(player: Player) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 100)
            .foregroundStyle(.offWhite)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(player.firstName) \(player.lastName)")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                    .bold()
                                Text("\(player.position)")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button("Add") {
                        Task {
                            await vm.addPlayerToLineupPressed(playerId: player.id)
                        }
                    }
                }
                .padding()
            }
    }
}

struct AddPlayerRowView: View {
    let vm: AddPlayerToLineupSheetViewModel
    let player: Player
    let url: URL?
    
    var body: some View {
        HStack(spacing: 12) {
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
                
                Text("\(player.position) • \(idSchoolPairs[player.teamId]!)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("\(vm.getOpponent(for: player) ?? "BYE")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button("Add") {
                Task {
                    await vm.addPlayerToLineupPressed(playerId: player.id)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
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
