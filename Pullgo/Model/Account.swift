//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

class Account: Codable {
    var username: String!
    var password: String?
    var fullName: String!
    var phone: String!
}

let PGSignedUser = _PGSignedUser.default
class _PGSignedUser: Codable {
    public static let `default` = _PGSignedUser()
    
    var token: String!
    var student: Student!
    var teacher: Teacher!
    
    enum CodingKeys: CodingKey {
        case token, student, teacher
    }
    
    var userType: UserType!
    var id: Int? {
        if self.userType == .student {
            return student.id
        } else if self.userType == .teacher {
            return teacher.id
        } else {
            fatalError("PGSignedUser::id -> userType not setted")
        }
    }
    
    private var userId: String {
        guard let userId = self.id else {
            fatalError("PGSignedUser::id -> id is nil.")
        }
        return String(userId)
    }
    
    // MARK: - SignIn Methods
    public func signIn(username: String, password: String, success: @escaping ((Data?) -> Void), fail: @escaping ((PGNetworkError) -> Void)) {
        let url = PGURLs.token
        let parameter: Parameter = ["username" : username, "password" : password]
        
        PGNetwork.post(url: url, parameter: parameter, fail: fail, success: success)
    }
    
    
    
    // MARK: - GET Methods
    public func getAcademies(page: Int, completion: @escaping (([Academy]) -> Void)) {
        let url = PGURLs.academies
            .appendingQuery([URLQueryItem(name: self.userType.toUserTypeId(), value: userId)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Academy].self) { completion($0) }
    }
    
    public func getApplyingAcademies(page: Int, completion: @escaping (([Academy]) -> Void)) {
        let url = PGURLs.academies
            .appendingQuery([URLQueryItem(name: self.userType.toApplyingUserTypeId(), value: userId)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Academy].self) { completion($0) }
    }
    
    public func getClassrooms(page: Int, completion: @escaping (([Classroom]) -> Void)) {
        let url = PGURLs.classrooms
            .appendingQuery([URLQueryItem(name: self.userType.toUserTypeId(), value: userId)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Classroom].self) { completion($0) }
    }
    
    public func getApplyingClassrooms(page: Int, completion: @escaping (([Classroom]) -> Void)) {
        let url = PGURLs.classrooms
            .appendingQuery([URLQueryItem(name: self.userType.toApplyingUserTypeId(), value: userId)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Classroom].self) { completion($0) }
    }
    
    public func getLessons(since: Date, until: Date, page: Int, completion: @escaping (([Lesson]) -> Void)) {
        let url = PGURLs.lessons
            .appendingQuery([URLQueryItem(name: self.userType.toUserTypeId(), value: userId),
                          URLQueryItem(name: "since", value: since.toString()),
                          URLQueryItem(name: "until", value: until.toString())])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Lesson].self) { completion($0) }
    }
    
    public func getExams(page: Int, completion: @escaping (([Exam]) -> Void)) {
        let url = PGURLs.exams
            .appendingQuery([URLQueryItem(name: self.userType.toUserTypeId(), value: userId)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Exam].self) { completion($0) }
    }
    
    public func applyAcademy(academyId: Int, completion: @escaping (() -> Void)) {
        let url = PGNetwork.appendURL(self.userType.toURLComponent(), userId, "apply-academy")
        let parameter: Parameter = ["academyId" : academyId]
        
        PGNetwork.post(url: url, parameter: parameter) { completion() }
    }
    
    public func removeApplyAcademy(academyId: Int, completion: @escaping (() -> Void)) {
        let url = PGNetwork.appendURL(self.userType.toURLComponent(), userId, "remove-applied-academy")
        let parameter: Parameter = ["academyId" : academyId]
        
        PGNetwork.post(url: url, parameter: parameter) { completion() }
    }

    public func applyClassroom(classroomId: Int, completion: @escaping (() -> Void)) {
        let url = PGNetwork.appendURL(self.userType.toURLComponent(), userId, "apply-classroom")
        let parameter: Parameter = ["classroomId" : classroomId]
        
        PGNetwork.post(url: url, parameter: parameter) { completion() }
    }
    
    public func removeApplyClassroom(classroomId: Int, completion: @escaping (() -> Void)) {
        let url = PGNetwork.appendURL(self.userType.toURLComponent(), userId, "remove-applied-classroom")
        let parameter: Parameter = ["classroomId" : classroomId]
        
        PGNetwork.post(url: url, parameter: parameter) { completion() }
    }
}

