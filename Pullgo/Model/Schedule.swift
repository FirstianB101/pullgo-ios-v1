//
//  Schedule.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

struct Schedule: Codable {
    var date: String
    
    /// Time Format: "hh:mm:ss"
    var beginTime: String
    var endTime: String
    
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.date == rhs.date && lhs.beginTime == rhs.beginTime && lhs.endTime == rhs.endTime
    }
}
