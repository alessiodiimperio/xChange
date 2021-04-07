//
//  DateFormat.swift
//  xChange
//
//  Created by Alessio on 2021-04-06.
//

import Foundation

final class DateFormat {
    static let dateFormatter = DateFormatter()
    
    static func shortDateLabel(for date: Date?) -> String {
        DateFormat.dateFormatter.dateStyle = .short
        
        if let date = date {
            return DateFormat.dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    static func mediumDateLabel(for date: Date?) -> String {
        DateFormat.dateFormatter.dateStyle = .medium
        
        if let date = date {
            return DateFormat.dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    static func longDateLabel(for date: Date?) -> String {
        DateFormat.dateFormatter.dateStyle = .long
        
        if let date = date {
            return DateFormat.dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
