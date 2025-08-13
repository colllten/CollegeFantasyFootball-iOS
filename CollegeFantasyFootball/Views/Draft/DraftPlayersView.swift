//
//  DraftPlayersView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/1/25.
//

import SwiftUI

struct DraftPlayersView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

final class DraftPlayersViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    
    let positions = ["QB", "RB", "WR", "TE", "P", "PK"]
    let schools = ["UCLA", "USC", "Northwestern", "Indiana", "Maryland", "Michigan State", "Michigan", "Minnesota", "Nebraska", "Rutgers", "Ohio State", "Penn State", "Washington", "Wisconsin", "Illinois", "Iowa", "Oregon", "Purdue"]
    
    var players: [Player] = []
    @Published var filteredPlayers: [Player] = []
    @Published var draftedPlayers: [Player] = []
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading DraftPlayerView data for fantasy league \(fantasyLeague.id)")
        
        isLoading = true
        do {
            players = try await fetchPlayers()
        } catch {
            LoggingManager
                .logError("Error loading DraftPlayerView data: \(error)")
            
            alertMessage = "Error loading draft data"
            showAlert = true
        }
        isLoading = false
    }
    
    /// Fetches all players within the schools
    private func fetchPlayers() async throws -> [Player] {
        LoggingManager
            .logInfo("Fetching players for draft")
        
        let fetchedPlayers: [Player] = try await supabase
            .from("Player")
            .select()
            .likeAnyOf("school", patterns: self.schools)
            .eq("season", value: season)
            .execute()
            .value
        
        return fetchedPlayers
    }
    
    private func fetchDraftPicks() async throws {
        LoggingManager
            .logInfo("Fetching draft picks for league \(fantasyLeague.id)")
        
    }
}

struct DraftPickDto: Equatable {
    
}

private struct DraftPicksResponse: Decodable {
    let id = UUID()
    let userId: String
    let round: UInt8
    let pick: UInt16
    var playerId: Int?
    let user: User
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case round = "round"
        case pick = "pick"
        case playerId = "player_id"
        case user = "User"
    }
    
    struct User: Decodable, Equatable {
        let username: String
        
        private enum CodingKeys: String, CodingKey {
            case username = "username"
        }
    }
}

#Preview {
    DraftPlayersView()
}
