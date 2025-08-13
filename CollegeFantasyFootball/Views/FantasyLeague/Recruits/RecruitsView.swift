//
//  TestView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import SwiftUI

struct RecruitsView: View {
    @ObservedObject var vm: NewRecruitsViewModel
    
    var body: some View {
        List {
            Section {
                TextField("Search for player", text: $vm.searchStr)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                    .textFieldStyle(.roundedBorder)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            
            Section {
                Picker("Position", selection: $vm.positionSelection) {
                    ForEach(vm.positions, id: \.self) { pos in
                        Text(pos).tag(pos)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                Picker("School", selection: $vm.schoolSelection) {
                    ForEach(vm.schools, id: \.self) { school in
                        Text(school).tag(school)
                    }
                }
                .pickerStyle(.menu)
            }

            ForEach(vm.availablePlayers, id: \.id) { player in
                PlayerRowView(vm: vm,
                              player: player,
                              url: vm.getPlayerImageUrl(playerId: player.id)
                )
                .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
        .task { await vm.loadData() }
    }
}

struct PlayerRowView: View {
    let vm: NewRecruitsViewModel
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
            }
            
            Spacer()
            
            Button("Recruit") {
                Task {
                    await vm.recruitButtonPressed(player: player)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
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

#Preview {
    RecruitsView(vm: NewRecruitsViewModel(fantasyLeague: FantasyLeague.mock))
}
