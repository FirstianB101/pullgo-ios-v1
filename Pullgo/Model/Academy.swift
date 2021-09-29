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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name       = try? container.decode(String.self, forKey: .name)
        self.phone      = try? container.decode(String.self, forKey: .phone)
        self.address    = try? container.decode(String.self, forKey: .address)
        self.ownerId    = try? container.decode(Int.self, forKey: .ownerId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.name, forKey: .name)
        try? container.encode(self.phone, forKey: .phone)
        try? container.encode(self.address, forKey: .address)
        try? container.encode(self.ownerId, forKey: .ownerId)
        
        try super.encode(to: encoder)
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
