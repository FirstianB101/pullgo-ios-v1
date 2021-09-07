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
    
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.date == rhs.date && lhs.beginTime == rhs.beginTime && lhs.endTime == rhs.endTime
    }
}
