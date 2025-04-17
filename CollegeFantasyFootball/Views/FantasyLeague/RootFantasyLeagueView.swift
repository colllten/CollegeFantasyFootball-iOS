//
//  RootFantasyLeagueView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import SwiftUI

struct RootFantasyLeagueView: View {
    let fantasyLeague: FantasyLeague
    @ObservedObject var vm: RootFantasyLeagueViewModel
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
        let viewModel = RootFantasyLeagueViewModel()
        viewModel.setViewState(fantasyLeague: fantasyLeague)
        self.vm = viewModel
    }
    
    var body: some View {
        ZStack {
            switch (vm.fantasyLeagueViewState) {
            case .preDraft:
                Text("pre")
            case .draftInProgress:
                Text("during")
            case .postDraft:
                Text("post")
            }
        }
        .onAppear {
            vm.setViewState(fantasyLeague: fantasyLeague)
        }
    }
}

#Preview {
    RootFantasyLeagueView(fantasyLeague: FantasyLeague.mock)
}
