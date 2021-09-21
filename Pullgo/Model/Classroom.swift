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
        case id
        case name
        case creatorId
        case academyId
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
    
    var requestTeachers = [Teacher]()
    var requestStudents = [Student]()
    var teachers = [Teacher]()
    var students = [Student]()
    var exams = [Exam]()
    
    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        return (
            rhs.id == lhs.id &&
            rhs.name == lhs.name &&
            rhs.creatorId == lhs.creatorId &&
            rhs.academyId == lhs.academyId
        )
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
        
        PGNetwork.get(url: url, type: [Teacher].self, completion: completion)
    }
    
    public func getAppliedTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendingQuery([self.appliedClassroomIdQuery])
        
        PGNetwork.get(url: url, type: [Teacher].self, completion: completion)
    }
    
    public func getStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.classroomIdQuery])
        
        PGNetwork.get(url: url, type: [Student].self, completion: completion)
    }
    
    public func getAppliedStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.appliedClassroomIdQuery])
        
        PGNetwork.get(url: url, type: [Student].self, completion: completion)
    }
    
    public func getExams(page: Int, completion: @escaping (([Exam]) -> Void)) {
        let url = PGURLs.exams.appendingQuery([self.classroomIdQuery])
        
        PGNetwork.get(url: url, type: [Exam].self, completion: completion)
    }
    
    public func accept(userType: UserType, userId: Int, completion: @escaping (() -> Void)) {
        let url = PGURLs.classrooms.appendingURL([self.classroomId, userType.toAcceptComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, completion: completion)
    }
    
    public func kick(userType: UserType, userId: Int, completion: @escaping (() -> Void)) {
        let url = PGURLs.classrooms.appendingURL([self.classroomId, userType.toKickComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, completion: completion)
    }
}
