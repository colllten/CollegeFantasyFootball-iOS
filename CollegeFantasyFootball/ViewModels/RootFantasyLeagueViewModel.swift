//
//  RootFantasyLeagueViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

final class RootFantasyLeagueViewModel: BaseViewModel {
    @Published var fantasyLeagueViewState = FantasyLeagueState.postDraft
    
    public func setViewState(fantasyLeague: FantasyLeague) {
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
