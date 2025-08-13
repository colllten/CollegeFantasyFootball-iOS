//
//  DraftView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/23/25.
//

import SwiftUI
import Supabase

struct DraftView: View {
    @State private var selectedTab: DraftTab = .draft
    @StateObject var vm: DraftViewModel
    
    var body: some View {
        VStack {
            liveDraftPickView
                .padding(.top)
            
            TabView(selection: $selectedTab) {
                Tab("Roster",
                    systemImage: "person.3.fill",
                    value: .roster) {
                    draftedRoster
                }
                
                Tab("Draft",
                    systemImage: "list.bullet.clipboard",
                    value: .draft) {
                    draftablePlayers
                }
                
                Tab("Draft Board",
                    systemImage: "flag",
                    value: .draftBoard) {
                    draftBoard
                }
            }
        }
        .frame(maxWidth: .infinity)
        .task {
            await vm.loadData()
            await vm.trySubscribeRealtime()
        }
        .onDisappear {
            Task {
                await vm.unsubscribeFromRealtime()
            }
        }
        .navigationDestination(isPresented: $vm.showFantasyLeagueView, destination: {
            FantasyLeagueView(fantasyLeague: vm.fantasyLeague)
        })
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
    
    
    private var draftedRoster: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.positions, id: \.self) { position in
                    ForEach(vm.draftedPlayers, id: \.id) { player in
                        if player.position == position {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 75)
                                .foregroundStyle(.offWhite)
                                .overlay {
                                    HStack {
                                        Text(player.position)
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundStyle(.gray)
                                            .frame(minWidth: 60)
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("\(player.firstName) \(player.lastName)")
                                                    .font(.title3)
                                                    .foregroundStyle(.blue)
                                                    .bold()
                                            }
                                            
                                            Text(idSchoolPairs[player.teamId]!)
                                                .font(.footnote)
                                                .foregroundStyle(.gray)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        
                                        Spacer()
                                    }
                                    .padding()
                                }
                        }
                    }
                }
            }
        }
    }
    
    private var liveDraftPickView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.draftPicks, id: \.pick) { pick in
                        DraftPickView(vm: vm,
                                      players: vm.players,
                                      pick: pick)
                            .id(pick.pick)
                    }
                }
                .padding(.horizontal, 16)
                .opacity(vm.draftPicks.isEmpty ? 0 : 1)
            }
            .frame(minHeight: 200)
            .background(Color(.systemBackground))
            .onChange(of: vm.draftPicks) { _, _ in
                vm.scrollToNextPick(proxy: proxy)
            }
        }
    }
    
    private var playerFilters: some View {
        HStack {
            Text("School")
            Picker("School", selection: $vm.schoolSelection) {
                ForEach(vm.schoolNames, id: \.self) { name in
                    Text("\(name)")
                }
            }
            .pickerStyle(.menu)
            
            Text("Position")
            Picker("Position", selection: $vm.positionSelection) {
                ForEach(vm.positions, id: \.self) { position in
                    Text("\(position)")
                }
            }
            .pickerStyle(.menu)
            
        }
    }
    
    private var draftBoard: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.draftBoardPlayers, id: \.id) { player in
                    draftPlayerRow(player: player, school: idSchoolPairs[player.teamId] ?? "")
                        .padding([.leading, .trailing])
                }
            }
        }
    }
    
    private var draftablePlayers: some View {
        VStack {
            playerFilters
            ScrollView {
                LazyVStack {
                    ForEach(vm.filteredPlayers, id: \.id) { player in
                        draftPlayerRow(player: player, school: idSchoolPairs[player.teamId] ?? "")
                            .padding([.leading, .trailing])
                    }
                }
            }
        }
    }
    
    private func draftPlayerRow(player: Player,
                                school: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 100)
            .foregroundStyle(.offWhite)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: vm.fetchImageUrl(playerId: player.id)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                case .failure:
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 75, height: 75)
                            VStack(alignment: .leading) {
                                Text("\(player.firstName) \(player.lastName)")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                    .bold()
                                Text("\(player.position), \(school)")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Spacer()
                    Button("Draft") {
                        Task {
                            await vm.tryDraftPlayer(playerId: player.id)
                        }
                    }
                    
                    Button {
                        Task {
                            await vm.draftBoardFlagPressed(playerId: player.id)
                        }
                    } label: {
                        Image(systemName: vm.draftBoardPlayers.contains(where: {
                            $0.id == player.id
                        }) ? "flag.fill" : "flag")
                    }
                    .padding(.leading)
                }
                .padding()
            }
    }
    
    enum DraftTab: Hashable {
        case roster
        case draft
        case draftBoard
    }
}

#Preview {
    NavigationStack {
        DraftView(vm: DraftViewModel(fantasyLeague: FantasyLeague.mock))
    }
}
