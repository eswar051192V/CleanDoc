//
//  DateExtension.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 20/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
extension String {
    func date(for pattern: String) -> Date? {
        let dateF = DateFormatter()
        dateF.timeZone = NSTimeZone.local
        dateF.dateFormat = pattern
        return dateF.date(from: self)
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func getDateString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateOnly() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func getTimeOnly() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return date.getDateOnly().compare(self.getDateOnly()) == .orderedSame
    }
    
    func next() -> Date {
        return self.addingTimeInterval(TimeInterval(24 * 60 * 60)).getDateOnly()
    }
    
    func previous() -> Date {
        return self.addingTimeInterval(TimeInterval((-24) * 60 * 60)).getDateOnly()
    }
    
    func isCurrentDate() -> Bool {
        let date = Date().getDateOnly().millisecondsSince1970
        return self.getDateOnly().millisecondsSince1970 == date
    }
    
    func isFutureDate() -> Bool {
        let date = Date().getDateOnly().millisecondsSince1970
        return self.getDateOnly().millisecondsSince1970 > date
    }
    
    func isCurrentOrFutureDate() -> Bool {
        return self.isFutureDate() || self.isCurrentDate()
    }
}
