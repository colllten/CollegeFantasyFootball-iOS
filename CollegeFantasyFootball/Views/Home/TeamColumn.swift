//
//  TeamColumn.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/7/25.
//

import SwiftUI

struct TeamColumn: View {
    let team: Team
    let url: URL?
    
    var body: some View {
        VStack {
            if team.logos == nil {
                Image("0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 40, height: 40)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    case .failure:
                        Image("0")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(team.school)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 100)
        }
    }
}

//#Preview {
//    TeamColumn()
//}
