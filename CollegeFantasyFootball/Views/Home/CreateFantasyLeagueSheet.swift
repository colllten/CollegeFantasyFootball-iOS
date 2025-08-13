//
//  CreateFantasyLeagueSheet.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/8/25.
//

import SwiftUI

struct CreateFantasyLeagueSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = CreateFantasyLeageSheetViewModel()
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                Button {
                    Task {
                        await vm.tryCreateFantasyLeague()
                    }
                } label: {
                    Text("Create League")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                Spacer()
            }
            Section {
                TextField("League Name", text: $vm.fantasyLeague.leagueName)
            }
            
            Section {
                DatePicker("Draft Date",
                           selection: $vm.fantasyLeague.draftDate,
                           displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
            }
            
            Section {
                Toggle("Point-Per-Reception?", isOn: $vm.fantasyLeague.ppr)
            }
            Section {
                Toggle("Include Kickers?", isOn: $vm.fantasyLeague.includeKickers)
            }
            Section {
                Toggle("Include Punters?", isOn: $vm.fantasyLeague.includePunters)
            }
            
            Section {
                Toggle("Custom Points?", isOn: $vm.fantasyLeague.customizePoints)
            }
            
            customPointFields
        }
        .formStyle(.grouped)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
        .onChange(of: vm.dismiss == false, {
            dismiss()
        })
    }
    
    var customPointFields: some View {
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
        .keyboardType(.decimalPad)
        .foregroundStyle(vm.fantasyLeague.customizePoints ? .primary : .secondary)
        .disabled(!vm.fantasyLeague.customizePoints)
    }
}

#Preview {
    NavigationStack {
        CreateFantasyLeagueSheetView()
            .navigationTitle("Create a Fantasy League")
            .toolbarTitleDisplayMode(.inline)
    }
}

