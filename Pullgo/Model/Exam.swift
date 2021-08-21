//
//  Exam.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Exam: Codable {
    var id: Int!
    var classroomId: Int!
    var creatorId: Int!
    var name: String!
    var beginDateTime: String!
    var endDateTime: String!
    var timeLimit: String!
    var passScore: Int!
    var cancelled: Bool!
    var finished: Bool!
    
    func getBeginDateTime() -> String {
        let beginDate = beginDateTime.toISO8601
        return beginDate.toString(format: "MM/dd HH:mm")
    }
    
    func getEndDateTime() -> String {
        let endDate = endDateTime.toISO8601
        return endDate.toString(format: "MM/dd HH:mm")
    }
    
    func getTimeLimit() -> String {
        let timeLimit = self.timeLimit.toISO8601
        return timeLimit.toString(format: "HH시간 mm분")
    }
}
