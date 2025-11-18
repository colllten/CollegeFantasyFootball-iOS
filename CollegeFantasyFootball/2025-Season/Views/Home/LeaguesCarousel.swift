//
//  LeaguesCarousel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/7/25.
//

import SwiftUI

struct LeaguesCarousel: View {
    let fantasyLeagues: [FantasyLeague]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {  // Add some spacing between cards
                ForEach(fantasyLeagues, id: \.id) { league in
                    NavigationLink {
                        RootFantasyLeagueView(
                            rootVm: RootFantasyLeagueViewModel(fantasyLeague: league),
                            draftVm: DraftViewModel(fantasyLeague: league))
                    } label: {
                        FantasyLeagueSubView(league: league)
                            .frame(width: 300, height: 180)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

//#Preview {
//    LeaguesCarousel()
//}
