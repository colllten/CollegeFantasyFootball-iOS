//
//  RootView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/10/25.
//

import SwiftUI

struct RootView: View {
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    var body: some View {
        if let userId, userId != "" {
            HomeView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    NavigationView {
        RootView()
    }
}
