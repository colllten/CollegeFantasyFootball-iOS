//
//  DraftPickView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/25/25.
//
import SwiftUI
import Supabase

struct DraftPickView: View {
    let vm: DraftViewModel
    let players: [Player]
    var pick: DraftViewModel.DraftPicksResponse

    var body: some View {
        let player = players.first { $0.id == pick.playerId }

        VStack(spacing: 8) {
            pickIdentifierText

            Text(pick.user.username)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Divider().padding(.vertical, 4)

            if let playerId = pick.playerId,
               let player = players.first(where: { $0.id == pick.playerId }) {
                VStack(spacing: 2) {
                    AsyncImage(url: vm.fetchImageUrl(playerId: playerId)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        case .failure:
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 75, height: 75)

                    Text(player.fullName)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(idSchoolPairs[player.teamId] ?? "")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Text(player.position)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            } else {
                Image(systemName: "hourglass")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(width: 75, height: 75)
                Spacer()
            }
        }
        .frame(width: 120, height: 180) // <-- enforce same size for all cards
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(pick.playerId == nil ? Color.yellow.opacity(0.15) : Color.green.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

    }
    
    private var pickIdentifierText: some View {
        HStack(spacing: 6) {
            Label("R\(pick.round)", systemImage: "circle.fill")
            Label("P\(pick.pick)", systemImage: "circle.fill")
        }
        .font(.caption2)
        .foregroundColor(.secondary)
        .labelStyle(TitleOnlyLabelStyle())
    }
}
