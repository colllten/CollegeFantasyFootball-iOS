//
//  MatchupView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/7/25.
//

import SwiftUI

struct MatchupView: View {
    @Environment(\.colorScheme) var colorScheme
    let game: GameSchedule
    let vm: HomeViewModel
    
    private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM d, h:mm a"
            return formatter
        }()

    var body: some View {
        HStack {
            TeamColumn(team: game.awayTeam,
                       url: vm.getTeamLogoStorageStr(teamId: game.awayTeam.id,
                                                     colorScheme: colorScheme)
            )
            
            Spacer()
            VStack {
                Text("vs")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("\(game.startDate != nil ? MatchupView.dateFormatter.string(from: game.startDate!) : "TBD")")
                    .font(.caption)
            }
            Spacer()
            
            TeamColumn(team: game.homeTeam,
                       url: vm.getTeamLogoStorageStr(teamId: game.homeTeam.id,
                                                     colorScheme: colorScheme))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


//#Preview {
//    MatchupView()
//}
