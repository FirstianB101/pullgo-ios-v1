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
    var cancelled: Bool?
    var finished: Bool?
    
    enum CodingKeys: CodingKey {
        case classroomId, creatorId, name, beginDateTime, endDateTime,
             timeLimit, passScore, cancelled, finished
    }
    
    init() {
        super.init(url: PGURLs.exams)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.classroomId    = try? container.decode(Int.self, forKey: .classroomId)
        self.creatorId      = try? container.decode(Int.self, forKey: .creatorId)
        self.name           = try? container.decode(String.self, forKey: .name)
        self.beginDateTime  = try? container.decode(String.self, forKey: .beginDateTime)
        self.endDateTime    = try? container.decode(String.self, forKey: .endDateTime)
        self.timeLimit      = try? container.decode(String.self, forKey: .timeLimit)
        self.passScore      = try? container.decode(Int.self, forKey: .passScore)
        self.cancelled      = try? container.decode(Bool.self, forKey: .cancelled)
        self.finished       = try? container.decode(Bool.self, forKey: .finished)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.classroomId, forKey: .classroomId)
        try? container.encode(self.creatorId, forKey: .creatorId)
        try? container.encode(self.name, forKey: .name)
        try? container.encode(self.beginDateTime, forKey: .beginDateTime)
        try? container.encode(self.endDateTime, forKey: .endDateTime)
        try? container.encode(self.timeLimit, forKey: .timeLimit)
        try? container.encode(self.passScore, forKey: .passScore)
        try? container.encode(self.cancelled, forKey: .cancelled)
        try? container.encode(self.finished, forKey: .finished)
        
        try super.encode(to: encoder)
    }
    
    override func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        let exam = Exam()
        
        guard let _ = self.id else {
            fatalError("Exam::patch() -> id is nil.")
        }
        exam.id = self.id!
        exam.name = self.name
        exam.beginDateTime = self.beginDateTime
        exam.endDateTime = self.endDateTime
        exam.timeLimit = self.timeLimit
        exam.passScore = self.passScore
        
        let url = PGURLs.exams.appendingURL([String(exam.id!)])
        guard let parameter = try? exam.toParameter() else {
            fatalError("Exam::patch() -> exam to parameter failed.")
        }
        
        PGNetwork.patch(url: url, parameter: parameter, success: success, fail: fail)
    }
    
    private var examId: String {
        guard let examId = self.id else {
            fatalError("Exam::id -> id is nil.")
        }
        return String(examId)
    }
    
    public func getBeginDateTime() -> String {
        let beginDate = beginDateTime.toISO8601
        return beginDate.toString(format: "M/d HH:mm")
    }
    
    public func getEndDateTime() -> String {
        let endDate = endDateTime.toISO8601
        return endDate.toString(format: "M/d HH:mm")
    }
    
    public func getTimeLimit() -> String {
        let timeLimits = self.timeLimit.split(separator: "H")
        let hour = timeLimits[0].filter { $0.isNumber }
        var minute = "0"
        
        if timeLimits.count >= 2 {
            minute = timeLimits[1].filter { $0.isNumber }
        }
        
        return "\(hour)시간 \(minute)분"
    }
    
    public func getAcademyAndClassroom(completion: @escaping ((Academy, Classroom) -> Void)) {
        self.getClassroom { classroom in
            classroom.getBelongedAcademy { academy in
                completion(academy, classroom)
            }
        }
    }
    
    private func getClassroom(completion: @escaping ((Classroom) -> Void)) {
        let url = PGURLs.classrooms.appendingURL([String(self.classroomId)])
        PGNetwork.get(url: url, type: Classroom.self) { classroom in
            completion(classroom)
        }
    }
    
    public func cancel(completion: @escaping ((Data?) -> Void)) {
        let url = PGURLs.exams
            .appendingURL([String(self.id!)])
            .appendingURL(["cancel"])
        
        PGNetwork.post(url: url, success: completion)
    }
    
    public func finish(completion: @escaping ((Data?) -> Void)) {
        let url = PGURLs.exams
            .appendingURL([String(self.id!)])
            .appendingURL(["finish"])
        
        PGNetwork.post(url: url, success: completion)
    }
}

extension Exam {
    private var examIdQuery: URLQueryItem {
        return URLQueryItem(name: "examId", value: self.examId)
    }
    
    private func setQuestionNumber(questions: inout [Question]) {
        for (index, question) in questions.enumerated() {
            question.questionNumber = index + 1
        }
    }
    
    public func getQuestions(page: Int, completion: @escaping (([Question]) -> Void)) {
        let url = PGURLs.questions.appendingQuery([self.examIdQuery])
            .pagination(page: page, size: 100)
        
        PGNetwork.get(url: url, type: [Question].self, success: { questions in
            var questionsWithNumber = questions
            self.setQuestionNumber(questions: &questionsWithNumber)
            
            completion(questionsWithNumber)
        })
    }
}
