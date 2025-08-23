//
//  CreditsView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/22/25.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
            VStack(spacing: 20) {
                Text("Credits")
                    .font(.largeTitle)
                    .bold()
                
                Text("This app uses data provided by CollegeFootballData.com")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Link("Visit CollegeFootballData.com",
                     destination: URL(string: "https://collegefootballdata.com")!)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
}

#Preview {
    NavigationStack {
        CreditsView()
    }
}
