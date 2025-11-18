//
//  InSeasonLeagueSettingsViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 9/1/25.
//

import Foundation

final class InSeasonLeagueSettingsViewModel: BaseViewModel {
    let fantasyLeague: FantasyLeague
    
    @Published var fantasyLeagueDto: FantasyLeagueDto?
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for InSeasonLeagueSettings")
        
        do {
            fantasyLeagueDto = try await fetchFantasyLeagueDto()
        } catch {
            let alertMsg = "Error loading data"
            LoggingManager
                .logError(alertMsg + ": \(error)")
            
            alertMessage = alertMsg
            showAlert = true
        }
    }
    
    private func fetchFantasyLeagueDto() async throws -> FantasyLeagueDto {
        LoggingManager
            .logInfo("Fetching fantasy league DTO")
        
        return try await supabase
            .from("FantasyLeague")
            .select(FantasyLeagueDto.selectAll())
            .eq("id", value: fantasyLeague.id)
            .eq("current_season", value: season)
            .single()
            .execute()
            .value
    }
}
