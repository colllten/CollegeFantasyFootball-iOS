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
                    Text("You must sign at player at this position")
                } else {
                    ForEach(vm.selectablePlayers, id: \.id) { player in
                        playerRow(player: player)
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

class AddPlayerToLineupSheetViewModel: BaseViewModel {
    @Published var dismiss = false
    let fantasyLeague: FantasyLeague
    let openPosition: String
    var fantasyLineup: FantasyLineup
    
    @Published var selectablePlayers = [Player]()
    
    init(
        fantasyLeague: FantasyLeague,
        openPosition: String,
        fantasyLineup: FantasyLineup
    ) {
        self.fantasyLeague = fantasyLeague
        self.openPosition = openPosition
        self.fantasyLineup = fantasyLineup
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for AddPlayerToLineupSheet")
        
        isLoading = true
        defer { isLoading = false }
                
        do {
            fantasyLineup = try await fetchLineup()
            
            let fantasyRosterPlayers = try await fetchFantasyRoster().rosterPlayers
            print(openPosition)
            
            switch openPosition {
            case "QB":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "QB"
                }
            case "RB":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "RB"
                }
            case "TE":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "TE"
                }
            case "WR1":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "WR"
                }
            case "WR2":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "WR"
                }
            case "FLEX":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    (
                        player.position == "RB"
                        ||
                        player.position == "TE"
                        ||
                        player.position == "WR"
                    )
                }
            case "P":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "P"
                }
            case "PK":
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "PK"
                }
            default:
                LoggingManager
                    .logWarning("Hit default")
                selectablePlayers = fantasyRosterPlayers.filter { player in
                    !fantasyLineup.playerIds.contains(player.id)
                    &&
                    player.position == "QB"
                }
            }
        } catch {
            let errorMsg = "Error loading data"
            LoggingManager
                .logError(errorMsg + ": \(error)")
            
            alertMessage = errorMsg
            showAlert = true
        }
    }
    
    private func fetchLineup() async throws -> FantasyLineup {
        LoggingManager
            .logInfo("Fetching fantasy lineup")
        
        return try await supabase
            .from("FantasyLineup")
            .select()
            .eq("season", value: season)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("league_id", value: fantasyLeague.id)
            .eq("week", value: fantasyLineup.week)
            .single()
            .execute()
            .value
    }
    
    private func fetchFantasyRoster() async throws -> FantasyRosterDto {
        LoggingManager
            .logInfo("Fetching fantasy roster")
        
        return try await supabase
            .from("FantasyRoster")
            .select("""
                fantasy_league:FantasyLeague!FantasyRoster_league_id_fkey(*),
                user:User!FantasyRoster_user_id_fkey(*),
                season,
                player_1:FantasyRoster_player_1_id_season_fkey(*),
                player_2:FantasyRoster_player_2_id_season_fkey(*),
                player_3:FantasyRoster_player_3_id_season_fkey(*),
                player_4:FantasyRoster_player_4_id_season_fkey(*),
                player_5:FantasyRoster_player_5_id_season_fkey(*),
                player_6:FantasyRoster_player_6_id_season_fkey(*),
                player_7:FantasyRoster_player_7_id_season_fkey(*),
                player_8:FantasyRoster_player_8_id_season_fkey(*),
                player_9:FantasyRoster_player_9_id_season_fkey(*),
                player_10:FantasyRoster_player_10_id_season_fkey(*),
                player_11:FantasyRoster_player_11_id_season_fkey(*),
                player_12:FantasyRoster_player_12_id_season_fkey(*)
                """)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("league_id", value: fantasyLeague.id)
            .eq("season", value: season)
            .single()
            .execute()
            .value
    }
    
    public func addPlayerToLineupPressed(playerId: Int) async {
        LoggingManager
            .logInfo("Add Player to Lineup pressed")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await updateFantasyLineup(playerId: playerId)
            dismiss = true
        } catch {
            let errorMsg = "Error adding player to lineup"
            LoggingManager
                .logError(errorMsg + "\(error)")
            
            alertMessage = errorMsg
            showAlert = true
        }
    }
    
    private func updateFantasyLineup(playerId: Int) async throws {
        LoggingManager
            .logInfo("Updating fantasy lineup")
        
        let column = switch openPosition {
        case "QB":
            "qb_id"
        case "RB":
            "rb_id"
        case "WR1":
            "wr1_id"
        case "WR2":
            "wr2_id"
        case "TE":
            "te_id"
        case "FLEX":
            "flex_id"
        case "P":
            "p_id"
        case "PK":
            "pk_id"
        default:
            // TODO: throw error
            "qb_id"
        }
        
        try await supabase
            .from("FantasyLineup")
            .update([
                column : playerId
            ])
            .eq("season", value: season)
            .eq("user_id", value: AuthManager.shared.currentUserId!)
            .eq("league_id", value: fantasyLeague.id)
            .eq("week", value: fantasyLineup.week)
            .execute()
    }
}
