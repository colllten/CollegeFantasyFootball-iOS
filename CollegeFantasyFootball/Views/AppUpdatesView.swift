//
//  AppUpdatesView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/28/25.
//

import SwiftUI

struct AppUpdatesView: View {
    @Environment(\.dismiss) var dismiss
    
    // Update this key each release (e.g., "hasSeen1.0.7")
    private let updateKey = "hasSeen1.0.6"
    
    @State private var hasSeenUpdate: Bool = UserDefaults.standard.bool(forKey: "hasSeen1.0.6")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What’s New in 1.0.6")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        UpdateRow(text: "Disabled league creation after August 29.")
                        UpdateRow(text: "Added ability to edit lineup before the collegiate football week has started.")
                        UpdateRow(text: "Bug fixes and performance improvements.")
                        UpdateRow(text: "NOTE: Players cannot be removed from a lineup once they have been picked for that position. This will be fixed in a future update.")
                    }
                    
                    Text("Thank you for your patience with updates to the app. Issues submitted within your profile tab are being investigated -- be sure to thoroughly describe the problem. We appreciate all your feedback.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.top, 24)
                    
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
