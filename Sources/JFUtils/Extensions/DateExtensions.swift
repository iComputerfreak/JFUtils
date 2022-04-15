//
//  DateExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import Foundation

public extension TimeZone {
    static let utc = TimeZone(secondsFromGMT: 0)!
}

public extension Calendar {
    /// The current calendar, using the UTC timezone
    static let utc: Calendar = {
        var c = Calendar.current
        c.timeZone = .utc
        return c
    }()
}

public extension Date {
    /// Returns the given calendar component of this date, using the given calendar
    subscript(_ component: Calendar.Component, calendar: Calendar = .current) -> Int {
        get {
            calendar.component(component, from: self)
        }
        set {
            self = calendar.date(bySetting: component, value: newValue, of: self)!
        }
    }
    
    /// Creates a new date using the given year, month, day and calendar
    /// - Parameters:
    ///   - year: The of the date to create
    ///   - month: The month of the date to create
    ///   - day: The day of the date to create
    ///   - calendar: The calendar to use for creating the date
    /// - Returns: The created date
    static func create(year: Int, month: Int = 1, day: Int = 1, calendar: Calendar = .current) -> Date {
        return calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }
    
    /// Returns the TimeInterval until midnight
    /// - Parameter calendar: The calendar to use
    /// - Returns: The time in seconds until midnight
    func timeIntervalUntilMidnight(calendar: Calendar = .current) -> TimeInterval {
        var midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
        midnight.addTimeInterval(.day)
        return midnight.timeIntervalSince(self)
    }
    
    /// The number of days in this month
    /// - Parameter calendar: The calendar to use
    /// - Returns: The number of days in this month
    func numberOfDaysInMonth(calendar: Calendar = .current) -> Int {
        let nextMonth = calendar.nextDate(after: self, matching: .init(day: 1), matchingPolicy: .nextTime)!
        let lastDay = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        return lastDay[.day]
    }
    
    /// Returns this date with all time components set to zero
    /// - Parameter calendar: The calendar to use
    /// - Returns: The date with all time components set to zero
    func timeErased(calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}

public extension TimeInterval {
    /// A TimeInterval equivalent to one minute
    static var minute: TimeInterval { 60 }
    /// A TimeInterval equivalent to one hour
    static var hour: TimeInterval { minute * 60 }
    /// A TimeInterval equivalent to one day
    static var day: TimeInterval { hour * 24 }
}
