//
//  RosterViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/15/25.
//

import Foundation

class RosterViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    
    let weeks = 1..<10
    
    @Published var weekSelection: Int = 1
    @Published var rosters: [Roster] = []
    @Published var rosterPlayers: RosterPlayers = RosterPlayers()
    @Published var showSwapSheet = false
    
    @Published var selectedPlayer: Player? = nil
    @Published var selectedRosterPosition = ""
    @Published var destinationPlayer: Player? = nil
    @Published var destinationRosterPosition = ""
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for RosterView")
        
        isLoading = true
        do {
            rosters = try await fetchRosters()
            rosterPlayers = try await fetchPlayersForRoster(week: 1) // TODO: Change week
        } catch {
            LoggingManager
                .logError("Error loading data: \(error)")
            
            alertMessage = "Error loading data"
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchRosters() async throws -> [Roster] {
        LoggingManager
            .logInfo("Fetching rosters")
        
        let userId = AuthManager.shared.currentUserId!
        var fetchedRosters: [Roster] = try await supabase
            .from("Roster")
            .select()
            .eq("league_id", value: fantasyLeague.id)
            .eq("user_id", value: userId)
            .execute()
            .value
        
        fetchedRosters = fetchedRosters.sorted(by: { roster1, roster2 in
            roster1.week < roster2.week
        })
        
        return fetchedRosters
    }
    
    private func fetchPlayersForRoster(week: Int) async throws -> RosterPlayers {
        LoggingManager
            .logInfo("Fetching players for roster")
        
        var roster = RosterPlayers()
        
        guard let weeklyRoster = rosters.first(where: { roster in
            roster.week == week
        }) else {
            // TODO: Throw error
            return RosterPlayers()
        }
        
        if let id = weeklyRoster.startingQbId {
            roster.startingQb = try await supabase
                .from("Player")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            print("qb")
        }
        if let id = weeklyRoster.startingRbId {
            roster.startingRb = try await supabase
                .from("Player")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
        }
        if let id = weeklyRoster.startingWr1Id {
            roster.startingWr1 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
        }
        if let id = weeklyRoster.startingWr2Id {
            roster.startingWr2 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
        }
        if let id = weeklyRoster.startingTeId {
            roster.startingTe = try await supabase
                .from("Player")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
        }
        if fantasyLeague.includeKickers {
            if let id = weeklyRoster.startingPkId {
                roster.startingPk = try await supabase
                    .from("Player")
                    .select()
                    .eq("id", value: id)
                    .single()
                    .execute()
                    .value
            }
        }
        if fantasyLeague.includePunters {
            if let id = weeklyRoster.startingPId {
                roster.startingP = try await supabase
                    .from("Player")
                    .select()
                    .eq("id", value: id)
                    .single()
                    .execute()
                    .value
            }
        }
        
        // Bench checks
        if let bench1Id = weeklyRoster.bench1Id {
            roster.bench1 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: bench1Id)
                .single()
                .execute()
                .value
        }
        if let bench2Id = weeklyRoster.bench2Id {
            roster.bench2 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: bench2Id)
                .single()
                .execute()
                .value
        }
        if let bench3Id = weeklyRoster.bench3Id {
            roster.bench3 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: bench3Id)
                .single()
                .execute()
                .value
        }
        if let bench4Id = weeklyRoster.bench4Id {
            roster.bench4 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: bench4Id)
                .single()
                .execute()
                .value
        }
        if let bench5Id = weeklyRoster.bench5Id {
            roster.bench5 = try await supabase
                .from("Player")
                .select()
                .eq("id", value: bench5Id)
                .single()
                .execute()
                .value
        }
        
        return roster
    }
}
