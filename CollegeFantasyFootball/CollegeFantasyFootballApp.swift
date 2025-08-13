//
//  CollegeFantasyFootballApp.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import SwiftUI

@main
struct CollegeFantasyFootballApp: App {
    init() {
        UserDefaults.standard.register(defaults: [
            "season": 2025
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .task {
                        await AuthManager.shared.loadSession()
                    }
            }
        }
    }
}
