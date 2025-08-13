//
//  FantasyLeagueView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/4/25.
//

import SwiftUI

struct FantasyLeagueView: View {
    let fantasyLeague: FantasyLeague
    @State private var focusView = FantasyLeagueViewFocus.schedule
    
    var body: some View {
        /// Name of league in navbar (inline)
        /// (tab) V scrollview of game schedule, top is prev. (show result), current in middle, bottom is future
        /// (tab) Scouting (sub 1)available free agents (sub2) transfer portal
        /// (tab) Edit roster
        TabView(selection: $focusView) {
            Tab("Recruit",
                systemImage: "binoculars",
                value: .scouting){
                RecruitsView(vm: NewRecruitsViewModel(fantasyLeague: fantasyLeague))
            }
            
            Tab("Schedule",
                systemImage: "figure.american.football",
                value: .schedule) {
                FantasyGameScheduleView(vm: FantasyGameScheduleViewModel(fantasyLeague: fantasyLeague))
            }
            
            Tab("Roster",
                systemImage: "person.3",
                value: .roster) {
                Text("To be implemented in a future update")
            }
        }
    }
    
    enum FantasyLeagueViewFocus: String {
        case scouting
        case schedule
        case roster
    }
}

#Preview {
    NavigationStack {
        FantasyLeagueView(fantasyLeague: FantasyLeague.mock)
    }
}
