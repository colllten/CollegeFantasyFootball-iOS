//
//  PlayersViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/9/25.
//

import SwiftUI

struct PlayersView: View {
    @ObservedObject var vm = PlayersViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.players, id: \.id) { player in
                    HStack {
                        AsyncImage(url: vm.fetchImageUrl(playerId: player.id)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }

                        Text("\(player.firstName) \(player.lastName)")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                Task {
                    await vm.loadData()
                }
            }
        }
        
    }
}

class PlayersViewModel: BaseViewModel {
    @Published var players: [Player] = []
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loaded data for PlayersView")
        
        isLoading = true
        do {
            players = try await fetchPlayers()
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            alertMessage = "Error loading data"
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching players")
        
        return try await supabase
            .from("Player")
            .select()
            .eq("season", value: 2025)
            .eq("team_id", value: 2509)
            .execute()
            .value
    }
    
    public func fetchImageUrl(playerId: Int) -> URL? {
        do {
            return try supabase
                .storage
                .from("player-headshots")
                .getPublicURL(path: "\(playerId).png")
        } catch {
            LoggingManager
                .logError("Error fetching headshot \(playerId)")
            return nil
        }
    }
}

#Preview {
    PlayersView()
}
