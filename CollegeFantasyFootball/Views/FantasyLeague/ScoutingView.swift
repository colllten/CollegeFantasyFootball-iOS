//
//  ScoutingView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/4/25.
//

import SwiftUI

struct ScoutingView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Recruits").tag(0)
                    Text("Transfer Portal").tag(1)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    TabView {
        Tab("Scouting", systemImage: "person.fill.viewfinder") {
            ScoutingView()
        }
        
        Tab("Schedule", systemImage: "american.football.fill") {
            Text("")
        }
        
        Tab("Roster", systemImage: "person.3.fill") {
            Text("")
        }
    }
}
