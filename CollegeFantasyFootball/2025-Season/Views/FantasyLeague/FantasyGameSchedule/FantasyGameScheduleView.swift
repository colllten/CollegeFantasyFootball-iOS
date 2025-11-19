//
//  FantasyGameScheduleView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/12/25.
//

import SwiftUI

struct FantasyGameScheduleView: View {
    @StateObject var vm: FantasyGameScheduleViewModel
    
    var body: some View {
        List {
            ForEach(sortedWeeks, id: \.self) { week in
                Section(header: Text("Week \(week)")) {
                    ForEach(gamesByWeek[week] ?? [], id: \.id) { game in
                        GameRow(game: game)
                            .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Schedule")
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .task { await vm.loadData() }
    }
    
    private var gamesByWeek: [Int: [FantasyGameDto]] {
        Dictionary(grouping: vm.allFantasyGames, by: { $0.week })
    }
    
    private var sortedWeeks: [Int] {
        gamesByWeek.keys.sorted()
    }
}

#Preview {
    NavigationStack {
        FantasyGameScheduleView(vm: FantasyGameScheduleViewModel(fantasyLeague: FantasyLeague.mock))
    }
}
