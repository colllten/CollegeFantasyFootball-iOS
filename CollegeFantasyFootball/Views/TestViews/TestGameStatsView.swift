//
//  TestGameStatsView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 6/11/25.
//

import SwiftUI

struct TestGameStatsView: View {
    @ObservedObject var vm: TestGameStatsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.gameStats, id: \.playerId) { stats in
                    Text("\(stats.player.firstName) \(stats.player.lastName)")
                    Text("\(stats.fantasyPoints(league: FantasyLeague.mock))")
                }
            }
        }
        .task {
            await vm.loadData()
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
    }
}

class TestGameStatsViewModel: BaseViewModel {
    @Published var gameStats = [GameStatsDto]()
    
    public func loadData() async {
        isLoading = true
        do {
            gameStats = try await fetchGameStats()
        } catch {
            LoggingManager
                .logError("Error fetching game stats \(error)")
            
            alertMessage = "Error fetching game stats"
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchGameStats() async throws -> [GameStatsDto] {
        return try await supabase
            .from("GameStats")
            .select("""
                *,
                Player!inner(first_name, last_name)
                """)
            .eq("game_id", value: 401628460)
            .execute()
            .value
    }
}

#Preview {
    NavigationStack {
        TestGameStatsView(vm: TestGameStatsViewModel())
    }
}
