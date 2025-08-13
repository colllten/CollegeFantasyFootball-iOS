//
//  FantasyLeagueSubView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/7/25.
//

import SwiftUI

struct FantasyLeagueSubView: View {
    var league: FantasyLeague
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(league.leagueName)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text("Draft Date: \(league.draftDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

