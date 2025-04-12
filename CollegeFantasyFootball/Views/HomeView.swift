//
//  HomeView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/9/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("User ID: \(UserDefaults.standard.string(forKey: "userId") ?? "no ID")")
            Button("Sign out") {
                UserDefaults.standard.removeObject(forKey: "userId")
            }
        }
    }
}

#Preview {
    HomeView()
}
