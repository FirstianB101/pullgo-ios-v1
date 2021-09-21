//
//  Schedule.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

@objc class Schedule: NSObject, Codable {
    /// Date Format: YYYY-MM-dd
    var date: String
    
    /// Time Format: "HH:mm:ss"
    var beginTime: String
    var endTime: String
    
    init(date: String, beginTime: String, endTime: String) {
        self.date = date
        self.beginTime = beginTime
        self.endTime = endTime
    }
    
    convenience init(date: Date, beginTime: Date, endTime: Date) {
        self.init(date: date.toString(),
                  beginTime: beginTime.toString(format: "HH:mm:ss"),
                  endTime: endTime.toString(format: "HH:mm:ss"))
    }
    
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.date == rhs.date && lhs.beginTime == rhs.beginTime && lhs.endTime == rhs.endTime
    }
}
