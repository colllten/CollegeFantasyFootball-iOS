//
//  GameRow.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import Foundation
import SwiftUI

struct GameRow: View {
    let game: FantasyGameDto
    
    var body: some View {
        NavigationLink {
            FantasyGameView(vm: FantasyGameViewModel(fantasyGame: game))
        } label: {
            content
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                )
        }
        .disabled(game.homeUser == nil || game.awayUser == nil)
    }
    
    @ViewBuilder
    private var content: some View {
        if game.homeUser == nil && game.awayUser == nil {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("No matchup")
                        .font(.headline)
                    Text("Both users are nil")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                playoffTagIfNeeded
            }
        } else if game.homeUser == nil || game.awayUser == nil {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.homeUser?.username ?? "BYE")
                        .font(.headline)
                    Text(game.awayUser?.username ?? "BYE")
                        .font(.headline)
                }
                Spacer()
                playoffTagIfNeeded
            }
        } else {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.homeUser?.username ?? "BYE")
                        .font(.headline)
                    Text(game.awayUser?.username ?? "BYE")
                        .font(.headline)
                    if game.isPlayoff {
                        Text("Playoff")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                
                Spacer()
                
                if let homeScore = game.homeScore,
                   let awayScore = game.awayScore {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(scoreString(homeScore))
                        Text(scoreString(awayScore))
                    }
                    .font(.headline)
                } else {
                    Text("Stats TBD")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var byeDescription: String {
        if game.homeUser != nil && game.awayUser == nil {
            return "Bye for Home"
        } else if game.homeUser == nil && game.awayUser != nil {
            return "Bye for Away"
        }
        return "Bye"
    }
    
    private var playoffTagIfNeeded: some View {
        Group {
            if game.isPlayoff {
                Label("Playoff", systemImage: "trophy")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }
    
    private func scoreString(_ value: Float) -> String {
        String(format: "%.1f", value)
    }
}
