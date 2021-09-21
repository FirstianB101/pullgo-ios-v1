//
//  Academy.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Academy: PGNetworkable {
    
    var name: String!
    var phone: String!
    var address: String!
    var ownerId: Int!
    
    enum CodingKeys: CodingKey {
        case name, phone, address, ownerId
    }
    
    private var academyId: String {
        guard let id = self.id else {
            fatalError("Academy::id is nil.")
        }
        return String(id)
    }
}

// MARK: - Network methods
extension Academy {
    
    private var academyIdQuery: URLQueryItem {
        return URLQueryItem(name: "academyId", value: academyId)
    }
    
    private var appliedAcademyIdQuery: URLQueryItem {
        return URLQueryItem(name: "appliedAcademyId", value: academyId)
    }
    
    // MARK: public methods
    public func getTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Teacher].self, completion: completion)
    }
    
    public func getAppliedTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendQuery([self.appliedAcademyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Teacher].self, completion: completion)
    }
    
    public func getStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Student].self, completion: completion)
    }
    
    public func getAppliedStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendQuery([self.appliedAcademyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Student].self, completion: completion)
    }
    
    public func getClassrooms(page: Int, completion: @escaping (([Classroom]) -> Void)) {
        let url = PGURLs.classrooms.appendQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Classroom].self, completion: completion)
    }
    
    public func accept(userType: UserType, userId: Int, completion: @escaping (() -> Void)) {
        let url = PGURLs.academies.appendURL(["\(academyId)", userType.toAcceptComponent()])
        let param: Parameter = [userType.toUserTypeId() : userId]
        
        PGNetwork.post(url: url, parameter: param, completion: completion)
    }
    
    public func kick(userType: UserType, userId: Int, completion: @escaping (() -> Void)) {
        let url = PGURLs.academies.appendURL(["\(academyId)", userType.toKickComponent()])
        let param: Parameter = [userType.toUserTypeId() : userId]
        
        PGNetwork.post(url: url, parameter: param, completion: completion)
    }
}
