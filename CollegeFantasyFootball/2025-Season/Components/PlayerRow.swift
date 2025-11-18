//
//  PlayerRow.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/10/25.
//

import SwiftUI

struct PlayerRow: View {
    let player: Player?
    let position: String
    let action: (Player) -> Void?
    let actionText: String?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 75)
            .foregroundStyle(.offWhite)
            .overlay {
                if player == nil {
                    nilPlayerDetails
                        .padding()
                } else {
                    playerDetails
                        .padding()
                }
            }
    }
    
    private var nilPlayerDetails: some View {
        HStack {
            Text(position)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.gray)
                .frame(minWidth: 90)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Open to Recruit")
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .bold()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            if actionText != nil {
                Button(actionText!) {
                    action(player!)
                }
                .padding()
            }
        }
    }
    
    private var playerDetails: some View {
        HStack {
            Text(position)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.gray)
                .frame(minWidth: 90)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(player!.firstName) \(player!.lastName)")
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .bold()
                }
                
                Text(idSchoolPairs[player!.teamId]!)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Spacer()
            
            if actionText != nil {
                Button(actionText!) {
                    action(player!)
                }
                .padding()
            }
        }
    }
}
