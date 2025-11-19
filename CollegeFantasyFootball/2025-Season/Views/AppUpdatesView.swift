//
//  AppUpdatesView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/28/25.
//

import SwiftUI

struct AppUpdatesView: View {
    @Environment(\.dismiss) var dismiss
    
    private let updateKey = "hasSeen1.0.8"
    
    @State private var hasSeenUpdate: Bool = UserDefaults.standard.bool(forKey: "hasSeen1.0.8")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What’s New in 1.0.8")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        UpdateRow(text: "Enhanced fantasy game lineup UI to include player headshot and school")
                        UpdateRow(text: "Added live game scoring on home screen")
                        UpdateRow(text: "Improved profile screen")
                        UpdateRow(text: "Included logs when submitting an issue")
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
