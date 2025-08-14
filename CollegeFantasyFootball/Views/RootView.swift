//
//  RootView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/10/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var auth = AuthManager.shared
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if auth.isLoadingSession {
                ProgressView("Loading…")
                    .progressViewStyle(CircularProgressViewStyle())
                    .animation(.default, value: auth.currentUser)
            } else if auth.currentUser != nil {
                if hasSeenOnboarding {
                    HomeView(vm: HomeViewModel())
                        .animation(.default, value: auth.currentUser)
                } else {
                    OnboardingView()
                }
            } else {
                SignInView()
                    .animation(.default, value: auth.currentUser)
            }
        }
        .id(auth.currentUser?.id)
        .animation(.default, value: auth.currentUser)
    }
}


#Preview {
    NavigationStack {
        RootView()
    }
}
