//
//  RootFantasyLeagueViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

final class RootFantasyLeagueViewModel: BaseViewModel {
    var fantasyLeague: FantasyLeague
    var fantasyLeagueViewState: FantasyLeagueState
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
        
        if !fantasyLeague.draftInProgress && !fantasyLeague.draftComplete {
            fantasyLeagueViewState = .preDraft
        } else if fantasyLeague.draftInProgress {
            fantasyLeagueViewState = .draftInProgress
        } else {
            fantasyLeagueViewState = .postDraft
        }
    }
}

enum FantasyLeagueState {
    case preDraft
    case draftInProgress
    case postDraft
}
