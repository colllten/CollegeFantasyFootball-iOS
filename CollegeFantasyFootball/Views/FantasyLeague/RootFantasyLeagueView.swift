//
//  RootFantasyLeagueView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import SwiftUI

struct RootFantasyLeagueView: View {
    @ObservedObject var rootVm: RootFantasyLeagueViewModel
    @ObservedObject var draftVm: DraftViewModel
    
    var body: some View {
        ZStack {
            switch (rootVm.fantasyLeagueViewState) {
            case .preDraft:
                PreDraftView(vm: PreDraftViewModel(fantasyLeague: rootVm.fantasyLeague))
            case .draftInProgress:
                DraftView(vm: draftVm)
            case .postDraft:
                FantasyLeagueView(fantasyLeague: rootVm.fantasyLeague)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootFantasyLeagueView(rootVm: RootFantasyLeagueViewModel(fantasyLeague: FantasyLeague.mock),
            draftVm: DraftViewModel(fantasyLeague: FantasyLeague.mock))
    }
}
