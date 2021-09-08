//
//  Extension.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import Foundation

extension String {
    var toISO8601: Date {
        get {
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: self + "+0000") else { return Date() }
            return date
        }
    }
    
    func predicate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

/// The type of key in the dictionary that uses the "YYYY-MM" format for key
typealias YearAndMonth = String

/// The type of key in the dictionary that uses the "YYYY-MM-dd" format for key.
typealias DateKey = String

// MARK: - Date Extensions
extension Date {
    
    /// base format = "YYYY-MM-dd"
    func toString(format: String = "YYYY-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func toKST() -> Date {
        return self.addingTimeInterval(9 * 3600)
    }
    
    var nextMonth: Date {
        get {
            return self + 40 * Date.day
        }
    }
    
    static var day: TimeInterval {
        get {
            return 24 * 60 * 60
        }
    }
    
    var firstDate: Date {
        get {
            let day = Double(self.toString(format: "dd"))! - 2
            
            return self - Date.day * day
        }
    }
    
    var isToday: Bool {
        return self.toString() == Date().toString()
    }
    
    var key: String {
        return self.toString()
    }
    
    var yearAndMonth: YearAndMonth {
        return self.toString(format: "YYYY-MM")
    }
}
