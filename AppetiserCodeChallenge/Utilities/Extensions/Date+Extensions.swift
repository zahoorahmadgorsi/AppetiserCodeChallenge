//
//  Date+Extensions.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 06/03/2025.
//

import Foundation

extension Date {
    func timeSinceAppClosed() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: self, to: Date())
        
        if let days = components.day, days > 0 {
            return "\(days) day(s) ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour(s) ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute(s) ago"
        } else {
            return "Just now"
        }
    }
}
