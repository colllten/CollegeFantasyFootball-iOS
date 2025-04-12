//
//  HomeView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import SwiftUI

struct HomeView: View {
    private var vm = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("User ID: \(UserDefaults.standard.string(forKey: "userId") ?? "no ID")")
            Button("Sign out") {
                vm.signOut()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
