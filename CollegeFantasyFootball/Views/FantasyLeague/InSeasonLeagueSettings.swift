//
//  InSeasonLeagueSettings.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 9/1/25.
//

import SwiftUI

struct InSeasonFantasyLeagueSettingsView: View {
    @StateObject var vm: InSeasonLeagueSettingsViewModel
    
    var body: some View {
        ScrollView {
            if vm.fantasyLeagueDto == nil {
                Text("Loading")
            } else {
                VStack(spacing: 20) {
                    // League Info
                    SectionView(title: "League Info", icon: "info.circle.fill") {
                        SettingsRow(label: "League Name", value: vm.fantasyLeagueDto!.leagueName, isHighlighted: true)
                        SettingsRow(label: "Owner", value: vm.fantasyLeagueDto!.owner.username)
                        SettingsRow(label: "Draft Date", value: vm.fantasyLeagueDto!.draftDate.formatted(date: .long, time: .shortened))
                    }
                    
                    SectionView(title: "Options", icon: "gear.circle.fill") {
                        ToggleRow(label: "PPR (Points per Reception)", isOn: vm.fantasyLeagueDto!.ppr)
                        ToggleRow(label: "Include Punters", isOn: vm.fantasyLeagueDto!.includePunters)
                        ToggleRow(label: "Include Kickers", isOn: vm.fantasyLeagueDto!.includeKickers)
                    }
                    
                    SectionView(title: "Passing", icon: "football.fill") {
                        Group {
                            PointsRow(label: "Points per Completion", value: vm.fantasyLeagueDto!.pointsPerCompletion)
                            PointsRow(label: "Points per Pass Yd", value: vm.fantasyLeagueDto!.pointsPerPassYd)
                            PointsRow(label: "Points per 10 Pass Yds", value: vm.fantasyLeagueDto!.pointsPer10PassYds)
                            PointsRow(label: "Points per 25 Pass Yds", value: vm.fantasyLeagueDto!.pointsPer25PassYds)
                            PointsRow(label: "Points per Pass TD", value: vm.fantasyLeagueDto!.pointsPerPassTd)
                            PointsRow(label: "Points per INT", value: vm.fantasyLeagueDto!.pointsPerInt)
                        }
                    }
                    
                    SectionView(title: "Rushing", icon: "figure.run") {
                        PointsRow(label: "Points per Rush Yd", value: vm.fantasyLeagueDto!.pointsPerRushYd)
                        PointsRow(label: "Points per 10 Rush Yds", value: vm.fantasyLeagueDto!.pointsPer10RushYds)
                        PointsRow(label: "Points per Rush TD", value: vm.fantasyLeagueDto!.pointsPerRushTd)
                    }
                    
                    SectionView(title: "Receiving", icon: "hand.raised.fill") {
                        PointsRow(label: "Points per Reception", value: vm.fantasyLeagueDto!.pointsPerRec)
                        PointsRow(label: "Points per Rec Yd", value: vm.fantasyLeagueDto!.pointsPerRecYd)
                        PointsRow(label: "Points per 10 Rec Yds", value: vm.fantasyLeagueDto!.pointsPer10RecYds)
                        PointsRow(label: "Points per Rec TD", value: vm.fantasyLeagueDto!.pointsPerRecTd)
                    }
                    
                    SectionView(title: "Special Teams", icon: "star.fill") {
                        PointsRow(label: "Points per KR TD", value: vm.fantasyLeagueDto!.pointsPerKickReturnTd)
                        PointsRow(label: "Points per PR TD", value: vm.fantasyLeagueDto!.pointsPerPuntReturnTd)
                    }
                    
                    if vm.fantasyLeagueDto!.includeKickers {
                        SectionView(title: "Kicking", icon: "target") {
                            PointsRow(label: "Points per FG Made", value: vm.fantasyLeagueDto!.pointsPerFgMade)
                            PointsRow(label: "Points per FG Miss", value: vm.fantasyLeagueDto!.pointsPerFgMiss)
                            PointsRow(label: "Points per XP Made", value: vm.fantasyLeagueDto!.pointsPerXpMade)
                            PointsRow(label: "Points per XP Miss", value: vm.fantasyLeagueDto!.pointsPerXpMiss)
                        }
                    }
                    
                    if vm.fantasyLeagueDto!.includePunters {
                        SectionView(title: "Punting", icon: "arrow.down.circle.fill") {
                            PointsRow(label: "Points per Punt Inside 20", value: vm.fantasyLeagueDto!.pointsPerPuntIn20)
                        }
                    }
                    
                    SectionView(title: "Other", icon: "ellipsis.circle.fill") {
                        PointsRow(label: "Points per Fumble Lost", value: vm.fantasyLeagueDto!.pointsPerFumbleLost)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("League Settings")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await vm.loadData()
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
        
    }
}

// MARK: - Reusable UI Helpers

struct SectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct SettingsRow: View {
    let label: String
    let value: String
    let isHighlighted: Bool
    
    init(label: String, value: String, isHighlighted: Bool = false) {
        self.label = label
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundColor(isHighlighted ? .primary : .secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(isHighlighted ? .semibold : .medium)
                .foregroundColor(isHighlighted ? .blue : .primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isHighlighted ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

struct PointsRow: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            HStack(spacing: 4) {
                Text(String(format: "%.2f", value))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

struct ToggleRow: View {
    let label: String
    let isOn: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isOn ? .green : .red)
                    .font(.title3)
                Text(isOn ? "Enabled" : "Disabled")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isOn ? .green : .red)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((isOn ? Color.green : Color.red).opacity(0.1))
            .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}
