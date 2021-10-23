//
//  Classroom.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation
import SwiftUI

typealias ClassroomParse = (classroomName: String, teacherName: String, weekday: String)

class Classroom: PGNetworkable {
    
    enum CodingKeys: String, CodingKey {
        case name, creatorId, academyId
    }
    
    private var classroomId: String {
        guard let id = self.id else {
            fatalError("Classroom::id -> id is nil.")
        }
        return String(id)
    }
    
    var name: String!
    var creatorId: Int!
    var academyId: Int!
    
    var academyBelong: Academy?
    
    init() {
        super.init(url: PGURLs.classrooms)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name       = try? container.decode(String.self, forKey: .name)
        self.creatorId  = try? container.decode(Int.self, forKey: .creatorId)
        self.academyId  = try? container.decode(Int.self, forKey: .academyId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.name, forKey: .name)
        try? container.encode(self.creatorId, forKey: .creatorId)
        try? container.encode(self.academyId, forKey: .academyId)
        
        try super.encode(to: encoder)
    }
    
    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        return (
            rhs.id == lhs.id &&
            rhs.name == lhs.name &&
            rhs.creatorId == lhs.creatorId &&
            rhs.academyId == lhs.academyId
        )
    }
    
    public override func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        let url = PGURLs.classrooms
            .appendingURL([self.classroomId])
        
        let classroom: Parameter = ["name" : self.name!]
        print(classroom)
        
        PGNetwork.patch(url: url, parameter: classroom, success: success, fail: fail)
    }

    var parse: ClassroomParse {
        var result: ClassroomParse = ("", "", "")
        guard let classroomName = self.name else { return result }
        
        let namePieces = classroomName.split(separator: ";")
        
        if namePieces.count != 3 { result.classroomName = classroomName; return result }
        print(classroomName)
        
        result.classroomName = String(namePieces[0])
        result.teacherName = String(namePieces[1]) + " 선생님"
        result.weekday = parseWeekday(weekday: namePieces[2])
        
        return result
    }
    
    public func setInformation(classroomName: String, teacherName: String, weekdays: String) {
        let weekday = weekdays.filter { str in
            if let _ = Weekday.init(rawValue: String(str)) {
                return true
            }
            return false
        }
        
        let combine = "\(classroomName);\(teacherName);\(weekday)"
        print(combine)
        self.name = combine
    }
    
    private func parseWeekday(weekday: String.SubSequence) -> String {
        let weekdayArray = weekday.map { "\($0), " }.joined()
        
        return removeLastComma(weekday: weekdayArray)
    }
    
    private func removeLastComma(weekday: String) -> String {
        var result = weekday
        result.removeLast()
        result.removeLast()
        return result
    }
}

extension Classroom {
    
    private var classroomIdQuery: URLQueryItem {
        return URLQueryItem(name: "classroomId", value: self.classroomId)
    }
    
    private var appliedClassroomIdQuery: URLQueryItem {
        return URLQueryItem(name: "appliedClassroomId", value: self.classroomId)
    }
    
    public func getTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendingQuery([self.classroomIdQuery])
        
        PGNetwork.get(url: url, type: [Teacher].self, success: completion)
    }
    
    public func getAppliedTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendingQuery([self.appliedClassroomIdQuery])
        
        PGNetwork.get(url: url, type: [Teacher].self, success: completion)
    }
    
    public func getStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.classroomIdQuery])
        
        PGNetwork.get(url: url, type: [Student].self, success: completion)
    }
    
    public func getAppliedStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.appliedClassroomIdQuery])
        
        PGNetwork.get(url: url, type: [Student].self, success: completion)
    }
    
    public func getCreator(completion: @escaping ((Teacher) -> Void)) {
        let url = PGURLs.teachers.appendingURL([String(self.creatorId)])
        
        PGNetwork.get(url: url, type: Teacher.self) { teacher in
            completion(teacher)
        }
    }
    
    public func getBelongedAcademy(completion: @escaping ((Academy) -> Void)) {
        let url = PGURLs.academies.appendingURL([String(self.academyId)])
        
        PGNetwork.get(url: url, type: Academy.self) { academy in
            completion(academy)
        }
    }
    
    public func getExams(page: Int, completion: @escaping (([Exam]) -> Void)) {
        let url = PGURLs.exams.appendingQuery([self.classroomIdQuery])
        
        PGNetwork.get(url: url, type: [Exam].self, success: completion)
    }
    
    public func accept(userType: UserType, userId: Int, completion: @escaping ((Data?) -> Void)) {
        let url = PGURLs.classrooms.appendingURL([self.classroomId, userType.toAcceptComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, success: completion)
    }
    
    public func kick(userType: UserType, userId: Int, completion: ((Data?) -> Void)? = nil) {
        let url = PGURLs.classrooms.appendingURL([self.classroomId, userType.toKickComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, success: completion)
    }
}
