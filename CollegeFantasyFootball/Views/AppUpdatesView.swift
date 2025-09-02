//
//  AppUpdatesView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/28/25.
//

import SwiftUI

struct AppUpdatesView: View {
    @Environment(\.dismiss) var dismiss
    
    private let updateKey = "hasSeen1.0.7"
    
    @State private var hasSeenUpdate: Bool = UserDefaults.standard.bool(forKey: "hasSeen1.0.7")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What’s New in 1.0.7")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        UpdateRow(text: "Added OTP sign in")
                        UpdateRow(text: "Added in-season fantasy league settings")
                        UpdateRow(text: "Edit Lineup UI improvements")
                        UpdateRow(text: "Added a player's opponent when selecting them to a lineup")
                    }
                    
                    Text("There are plenty more updates to come this season!")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.top, 24)
                }
                .padding()
            }
            .navigationTitle("App Updates")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        UserDefaults.standard.set(true, forKey: updateKey)
                        hasSeenUpdate = true
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    AppUpdatesView()
}
