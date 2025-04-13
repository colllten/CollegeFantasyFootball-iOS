//
//  RootFantasyLeagueViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

final class RootFantasyLeagueViewModel: BaseViewModel {
    @Published var fantasyLeagueViewState = FantasyLeagueState.preDraft
    var fantasyLeague: FantasyLeague
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
        
        if Date.now < fantasyLeague.draftDate || (Date.now >= fantasyLeague.draftDate && !fantasyLeague.draftInProgress) {
            fantasyLeagueViewState = .preDraft
        } else if Date.now >= fantasyLeague.draftDate && fantasyLeague.draftInProgress {
            fantasyLeagueViewState = .draftInProgress
        } else {
            fantasyLeagueViewState = .postDraft
        }
    }
    
    enum FantasyLeagueState {
        case preDraft
        case draftInProgress
        case postDraft
    }
}
