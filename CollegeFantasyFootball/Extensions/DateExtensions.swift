//
//  DateExtensions.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/10/25.
//

import Foundation

extension Date {
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func monthAndDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a z"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
