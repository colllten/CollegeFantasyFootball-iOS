//
//  RootView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/10/25.
//

import SwiftUI

struct RootView: View {
    @State var userId = UserDefaults.standard.string(forKey: "userId")
    
    var body: some View {
        if (userId != nil && userId! != "") {
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
