//
//  PreDraftView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/15/25.
//

import SwiftUI

struct PreDraftView: View {
    let fantasyLeague: FantasyLeague
    @State private var countdownText: String = ""
    @State private var backgroundColors: [Color] = [.red, .orange, .purple]
    @State private var days = 0
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: backgroundColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(days, format: .number)
                    Text(hours, format: .number)
                    Text(minutes, format: .number)
                    Text(seconds, format: .number)
                }
                .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(days == 1 ? "DAY" : "DAYS")
                    Text(hours == 1 ? "HOUR" : "HOURS")
                    Text(minutes == 1 ? "MINUTE" : "MINUTES")
                    Text(seconds == 1 ? "SECOND" : "SECONDS")
                }
            }
            .font(.largeTitle)
            .fontDesign(.monospaced)
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            // Updating background color looks very choppy if it is not in
            // separate scheduled timers and does not have different duration
            // than its scheduled timer
            .onAppear {
                updateCountdown()
                // Update every second
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    updateCountdown()
                    withAnimation(.smooth(duration: .pi)) {
                        updateBackgroundColorOrder()
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    withAnimation(.smooth(duration: .pi)) {
                        updateBackgroundColorOrder()
                    }
                }
            }
        }
    }
    
    ///
    /// Shifts background colors to the index + 1 and wraps back to beginning
    ///
    private func updateBackgroundColorOrder() {
        for index in backgroundColors.indices {
            if index < backgroundColors.count - 1 {
                let temp = backgroundColors[index]
                backgroundColors[index] = backgroundColors[index + 1]
                backgroundColors[index + 1] = temp
            }
        }
    }
    
    ///
    /// Updates displayed date components
    ///
    private func updateCountdown() {
        let now = Date()
        let target = fantasyLeague.draftDate
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: target)
        
        if let day = components.day,
           let hour = components.hour,
           let minute = components.minute,
           let second = components.second {
            days = day
            hours = hour
            minutes = minute
            seconds = second
        } else {
            countdownText = "Invalid date"
        }
    }
}

#Preview {
    PreDraftView(fantasyLeague: FantasyLeague.mock)
}
