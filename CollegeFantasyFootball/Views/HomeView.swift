//
//  HomeView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    LeaguesCarousel(fantasyLeagues: vm.fantasyLeagues)
//                        CustomNavigationLink(title: "Create League", destination: CreateFantasyLeagueSheetView())
                }
                .navigationTitle("Home")
                .padding(.horizontal)
            }
        }
        .task {
            await vm.loadData()
        }
        .navigationBarBackButtonHidden()
        .withLoading(vm.isLoading)
//        .toolbar {
//            NavigationLink(destination: ProfileView(vm: ProfileViewModel(appUser: appUser))) {
//                Image(systemName: "person.circle")
//                    .font(.title2)
//            }
//        }
    }
}

struct FantasyLeagueSubView: View {
    var league: FantasyLeague
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(league.leagueName)
                .font(.title2)
                .bold()
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity)
            
            Text("Season: \(league.currentSeason.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Draft Date: \(league.draftDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.footnote)
                .foregroundColor(.secondary)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}


struct LeaguesCarousel: View {
    let fantasyLeagues: [FantasyLeague]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(fantasyLeagues, id: \.id) { league in
                    NavigationLink {
//                        FantasyLeagueView(fantasyLeagueId: league.id)
                    } label: {
                        FantasyLeagueSubView(league: league)
                            .frame(width: 300, height: 180)
                            .padding(.horizontal)
                            .padding(.leading)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
