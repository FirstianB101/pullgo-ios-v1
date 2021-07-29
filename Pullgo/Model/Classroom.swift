//
//  Classroom.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation
import SwiftUI

typealias ClassroomParse = (classroomName: String, teacherName: String, weekday: String)

class Classroom: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creatorId
        case academyId
    }
    
    var id: Int?
    var name: String?
    var creatorId: Int!
    var academyId: Int!
    
    var academyBelong: Academy?
    
    var requestTeachers = [Teacher]()
    var requestStudents = [Student]()
    var teachers = [Teacher]()
    var students = [Student]()
    
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

// Do Network Process
extension Classroom {
    
    func getStudents(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("students")
        url.appendQuery(query: URLQueryItem(name: "classroomId", value: String(self.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedStudents = try? data?.toObject(type: [Student].self) else {
                fatalError("Classroom.getStudents() -> data parse error")
            }
            self.students = receivedStudents
        }
        
        let fail: EmptyClosure = { }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    func getTeachers(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("teachers")
        url.appendQuery(query: URLQueryItem(name: "classroomId", value: String(self.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedTeachers = try? data?.toObject(type: [Teacher].self) else {
                fatalError("Classroom.getTeachers() -> data parse error")
            }
            self.teachers = receivedTeachers
        }
        
        let fail: EmptyClosure = { }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    func getRequestStudents(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("students")
        url.appendQuery(query: URLQueryItem(name: "appliedClassroomId", value: String(self.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedRequestStudents = try? data?.toObject(type: [Student].self) else {
                fatalError("Classroom.getRequestStudents() -> data parse error")
            }
            self.requestStudents = receivedRequestStudents
        }
        
        let fail: EmptyClosure = { /*self.networkAlertDelegate?.networkFailAlert()*/ }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    func getRequestTeachers(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("teachers")
        url.appendQuery(query: URLQueryItem(name: "appliedClassroomId", value: String(self.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedRequestTeachers = try? data?.toObject(type: [Teacher].self) else {
                fatalError("Classroom.getRequestTeachers() -> data parse error")
            }
            self.requestTeachers = receivedRequestTeachers
        }
        
        let fail: EmptyClosure = { /*self.networkAlertDelegate?.networkFailAlert()*/ }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
}
