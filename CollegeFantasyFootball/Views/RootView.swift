//
//  RootView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/10/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        if userId != "" {
            HomeView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
    }
}
