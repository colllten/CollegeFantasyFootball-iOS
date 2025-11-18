//
//  FantasyLeagueSettingsView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/16/25.
//

import SwiftUI

struct FantasyLeagueSettingsView: View {
    @ObservedObject var vm: FantasyLeagueSettingsViewModel
    
    var body: some View {
        Form {
            Button("Save changes") {
                Task {
                    await vm.saveSettings()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .bold()
            
            Section("League Name") {
                TextField("", text: $vm.fantasyLeague.leagueName)
                    .disabled(true)
                    .foregroundStyle(.gray)
            }
            Section("Draft Date") {
                DatePicker("", selection: $vm.fantasyLeague.draftDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            Section {
                Toggle("Point-Per-Reception", isOn: $vm.fantasyLeague.ppr)
            }
            Section {
                Toggle("Kickers", isOn: $vm.fantasyLeague.includeKickers)
            }
            Section {
                Toggle("Punters", isOn: $vm.fantasyLeague.includePunters)
            }
            Section {
                Toggle("Customize Points?", isOn: $vm.fantasyLeague.customizePoints)
            }
            if vm.fantasyLeague.customizePoints {
                customizePointFields
            }
        }
        .withLoading(vm.isLoading)
        .navigationTitle("League Settings")
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
    
    private var customizePointFields: some View {
        Group {
            Section("Points per Completion") {
                NumberField($vm.fantasyLeague.pointsPerCompletion)
            }
            Section("Points per Pass Yard") {
                NumberField($vm.fantasyLeague.pointsPerPassYd)
            }
            Section("Points per 10 Pass Yards") {
                NumberField($vm.fantasyLeague.pointsPer10PassYds)
            }
            Section("Points per 25 Pass Yards") {
                NumberField($vm.fantasyLeague.pointsPer25PassYds)
            }
            Section("Points per Pass TD") {
                NumberField($vm.fantasyLeague.pointsPerPassTd)
            }
            Section("Points per Interception") {
                NumberField($vm.fantasyLeague.pointsPerInt)
            }
            Section("Points per Rush Yard") {
                NumberField($vm.fantasyLeague.pointsPerRushYd)
            }
            Section("Points per 10 Rush Yards") {
                NumberField($vm.fantasyLeague.pointsPer10RushYds)
            }
            Section("Points per Rush TD") {
                NumberField($vm.fantasyLeague.pointsPerRushTd)
            }
            if vm.fantasyLeague.ppr {
                Section("Points per Reception") {
                    NumberField($vm.fantasyLeague.pointsPerRec)
                }
            }
            Section("Points per Receiving Yard") {
                NumberField($vm.fantasyLeague.pointsPerRecYd)
            }
            Section("Points per 10 Receiving Yards") {
                NumberField($vm.fantasyLeague.pointsPer10RecYds)
            }
            Section("Points per Receiving TD") {
                NumberField($vm.fantasyLeague.pointsPerRecTd)
            }
            Section("Points per Kick Return TD") {
                NumberField($vm.fantasyLeague.pointsPerKickReturnTd)
            }
            Section("Points per Punt Return TD") {
                NumberField($vm.fantasyLeague.pointsPerPuntReturnTd)
            }
            if vm.fantasyLeague.includeKickers {
                Section("Points per Field Goal Made") {
                    NumberField($vm.fantasyLeague.pointsPerFgMade)
                }
                Section("Points per Field Goal Miss") {
                    NumberField($vm.fantasyLeague.pointsPerFgMiss)
                }
                Section("Points per Extra Point Made") {
                    NumberField($vm.fantasyLeague.pointsPerXpMade)
                }
                Section("Points per Extra Point Miss") {
                    NumberField($vm.fantasyLeague.pointsPerXpMiss)
                }
            }
            if vm.fantasyLeague.includePunters {
                Section("Points per Punt within 20") {
                    NumberField($vm.fantasyLeague.pointsPerPuntIn20)
                }
            }
            Section("Points per Fumble Lost") {
                NumberField($vm.fantasyLeague.pointsPerFumbleLost)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FantasyLeagueSettingsView(vm: FantasyLeagueSettingsViewModel(fantasyLeague: FantasyLeague.mock))
    }
}
