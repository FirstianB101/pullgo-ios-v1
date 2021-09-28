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
    
    init() {
        super.init(url: PGURLs.academies)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
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
        let url = PGURLs.teachers.appendingQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Teacher].self, success: completion)
    }
    
    public func getAppliedTeachers(page: Int, completion: @escaping (([Teacher]) -> Void)) {
        let url = PGURLs.teachers.appendingQuery([self.appliedAcademyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Teacher].self, success: completion)
    }
    
    public func getStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Student].self, success: completion)
    }
    
    public func getAppliedStudents(page: Int, completion: @escaping (([Student]) -> Void)) {
        let url = PGURLs.students.appendingQuery([self.appliedAcademyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Student].self, success: completion)
    }
    
    public func getClassrooms(page: Int, completion: @escaping (([Classroom]) -> Void)) {
        let url = PGURLs.classrooms.appendingQuery([self.academyIdQuery]).pagination(page: page)
        
        PGNetwork.get(url: url, type: [Classroom].self, success: completion)
    }
    
    public func accept(userType: UserType, userId: Int, completion: @escaping ((Data?) -> Void)) {
        let url = PGURLs.academies.appendingURL(["\(academyId)", userType.toAcceptComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, success: completion)
    }
    
    public func kick(userType: UserType, userId: Int, completion: @escaping ((Data?) -> Void)) {
        let url = PGURLs.academies.appendingURL(["\(academyId)", userType.toKickComponent()])
        let parameter = userType.toParameter(userId: userId)
        
        PGNetwork.post(url: url, parameter: parameter, success: completion)
    }
}
