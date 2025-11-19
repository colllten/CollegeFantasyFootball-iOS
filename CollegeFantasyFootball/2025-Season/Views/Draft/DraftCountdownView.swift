//
//  DraftCountdownView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/10/25.
//

import SwiftUI

struct DraftCountdownView: View {
    let draftDate: Date
    
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timeRemainingString)
            .font(.headline)
            .onReceive(timer) { input in
                now = input
            }
    }
    
    private var timeRemaining: TimeInterval {
        max(draftDate.timeIntervalSince(now), 0)
    }
    
    private var timeRemainingString: String {
        let totalSeconds = Int(timeRemaining)
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if days > 0 {
            return "\(days)d \(hours)h \(minutes)m \(seconds)s"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else {
            return "\(minutes)m \(seconds)s"
        }
    }
}

#Preview {
    DraftCountdownView(draftDate: .now + 10)
}
