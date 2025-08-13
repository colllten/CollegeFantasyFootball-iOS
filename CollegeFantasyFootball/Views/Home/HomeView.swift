//
//  HomeView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import SwiftUI
import StoreKit

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                leaguesSection
                scheduleSection
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            createLeagueButton
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5)
                .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ProfileView(vm: ProfileViewModel())
                } label: {
                    Image(systemName: "person.circle")
                        .imageScale(.large)
                        .accessibilityLabel("Profile")
                        .padding(8)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    NotificationsView(vm: NotificationsViewModel())
                } label: {
                    Image(systemName: vm.hasUnansweredNotifications ? "bell.badge.fill" : "bell.fill")
                        .imageScale(.large)
                        .accessibilityLabel("Notifications")
                        .padding(8)
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await vm.loadData()
            }
        }
        .refreshable {
            Task {
                await vm.loadData()
            }
        }
        .alert("Error", isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.alertMessage)
        }
        .alert(vm.updateAlertMessage, isPresented: $vm.showUpdateAlert, actions: {
            Button {
                let url = URL(string: "itms-apps://itunes.apple.com/")
                UIApplication.shared.open(url!)
            } label: {
                Text("App Store")
            }
        })
        .withLoading(vm.isLoading)
    }
    
    private var leaguesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Leagues")
                .font(.title3)
                .bold()
                .padding([.horizontal, .top])
            
            if vm.fantasyLeagues.isEmpty {
                NavigationLink(destination: CreateFantasyLeagueSheetView()) {
                    VStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.accentColor)
                        Text("Create a Fantasy League")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                    .frame(maxWidth: .infinity, minHeight: 140)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal, 8)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                LeaguesCarousel(fantasyLeagues: vm.fantasyLeagues.sorted { $0.leagueName < $1.leagueName })
                    .padding(.horizontal, 8)
            }
        }
        .padding(.bottom)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.title3)
                .bold()
                .padding([.horizontal, .top])
            
            Picker("Week", selection: $vm.weekSelection) {
                ForEach(vm.weeks, id: \.self) { week in
                    Text("Week \(week)").tag(week)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal, 8)
            
            if vm.selectedWeekGames.isEmpty {
                Text("No games scheduled for this week.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal, 8)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(vm.selectedWeekGames, id: \.id) { game in
                        MatchupView(game: game, vm: vm)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var createLeagueButton: some View {
        NavigationLink(destination: CreateFantasyLeagueSheetView()) {
            Text("Create League")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(12)
                .accessibilityAddTraits(.isButton)
        }
    }
}


#Preview {
    NavigationStack {
        HomeView(vm: HomeViewModel())
    }
}
