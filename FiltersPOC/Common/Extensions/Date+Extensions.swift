//
//  Date+ComparisonExtensions.swift
//  Dior Retail App
//
//  Created by itay gervash on 26/10/2022.
//  Copyright © 2022 Balink. All rights reserved.
//

import Foundation

public extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the larges date component from now
    ///
    /// - Warning: Returns a positive value for both future and past dates.
    /// - Warning: Works only with [.year, .month, .day, .hour, .minute, .second]
    func largestComponentFromNow() -> (Calendar.Component, Int) {
        let yearsFromNow = abs(yearsFromNow())
        let monthsFromNow = abs(monthsFromNow())
        let daysFromNow = abs(daysFromNow())
        let hoursFromNow = abs(hoursFromNow())
        let minutesFromNow = abs(minutesFromNow())
        let secondsFromNow = abs(secondsFromNow())
        
        if yearsFromNow > 0 {
            return (.year, yearsFromNow)
        } else if monthsFromNow > 0 {
            return (.month, monthsFromNow)
        } else if daysFromNow > 0 {
            return (.day, daysFromNow)
        } else if hoursFromNow > 0 {
            return (.hour, hoursFromNow)
        } else if minutesFromNow > 0 {
            return (.minute, minutesFromNow)
        } else {
            return (.second, secondsFromNow)
        }
    }
    
    /// Returns the amount of years from now
    func yearsFromNow() -> Int {
        return Calendar.current.dateComponents([.year], from: Date(), to: self).year ?? 0
    }
    /// Returns the amount of months from now
    func monthsFromNow() -> Int {
        return Calendar.current.dateComponents([.month], from: Date(), to: self).month ?? 0
    }
    /// Returns the amount of weeks from now
    func weeksFromNow() -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from now
    func daysFromNow() -> Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
    }
    /// Returns the amount of hours from now
    func hoursFromNow() -> Int {
        return Calendar.current.dateComponents([.hour], from: Date(), to: self).hour ?? 0
    }
    /// Returns the amount of minutes from now
    func minutesFromNow() -> Int {
        return Calendar.current.dateComponents([.minute], from: Date(), to: self).minute ?? 0
    }
    /// Returns the amount of seconds from now
    func secondsFromNow() -> Int {
        return Calendar.current.dateComponents([.second], from: Date(), to: self).second ?? 0
    }
    
    /// Returns a date with the specified amount of seconds added to the original value
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
    
    /// Returns a date with the specified amount of minutes added to the original value
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    /// Returns a date with the specified amount of hours added to the original value
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    /// Returns a date with the specified amount of days added to the original value
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Returns a date with the specified amount of weeks added to the original value
    func addingWeeks(_ weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }

    /// Returns a date with the specified amount of months added to the original value
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    /// Returns a date with the specified amount of years added to the original value
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    /// a Boolean value representing if the date is in the future
    var isInTheFuture: Bool {
        return self > Date()
    }
    
    /// a Boolean value representing if the date is today
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// a Boolean value representing if the date is in the past
    var isInThePast: Bool {
        return self < Date()
    }
    
    /// formats a date to a text sentence with the value of days relative for today
    ///
    /// - returns 3 days ago for a date 3 days in the past
    /// - returns today for todays date
    /// - returns 2 days left for a date 2 days in the future
    var daysLeftFromNowLocalized: String {
        let calendarDaysFromSelf = abs(self.startOfDay().days(from: Date().startOfDay()))
        
        if self.isInToday {
            return "Today"
            
        } else if self.isInThePast {
            
            return String(calendarDaysFromSelf) + " " + (calendarDaysFromSelf == 1 ? "Day Ago" : "Days Ago")
            
        } else {
            return String(calendarDaysFromSelf) + " " + (calendarDaysFromSelf == 1 ? "Day Left" : "Days Left")
        }
    }

}
