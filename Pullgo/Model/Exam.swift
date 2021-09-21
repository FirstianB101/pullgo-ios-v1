//
//  Exam.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Exam: PGNetworkable {
    
    var classroomId: Int!
    var creatorId: Int!
    var name: String!
    var beginDateTime: String!
    var endDateTime: String!
    var timeLimit: String!
    var passScore: Int!
    var cancelled: Bool!
    var finished: Bool!
    
    private var examId: String {
        guard let examId = self.id else {
            fatalError("Exam::id -> id is nil.")
        }
        return String(examId)
    }
    
    func getBeginDateTime() -> String {
        let beginDate = beginDateTime.toISO8601
        return beginDate.toString(format: "MM/dd HH:mm")
    }
    
    func getEndDateTime() -> String {
        let endDate = endDateTime.toISO8601
        return endDate.toString(format: "MM/dd HH:mm")
    }
    
    func getTimeLimit() -> String {
        let timeLimits = self.timeLimit.split(separator: "H")
        let hour = timeLimits[0].filter { $0.isNumber }
        var minute = "0"
        
        if timeLimits.count >= 2 {
            minute = timeLimits[1].filter { $0.isNumber }
        }
        
        return "\(hour)시간 \(minute)분"
    }
}

extension Exam {
    private var examIdQuery: URLQueryItem {
        return URLQueryItem(name: "examId", value: self.examId)
    }
    
    public func getQuestions(page: Int, completion: @escaping (([Question]) -> Void)) {
        let url = PGURLs.questions.appendingQuery([self.examIdQuery])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Question].self, completion: completion)
    }
}
