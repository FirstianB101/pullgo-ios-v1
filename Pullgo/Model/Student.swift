//
//  Student.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//
import Foundation

class Student: PGNetworkable {
    
    var token: String?
    var account: Account!
    var parentPhone: String!
    var schoolName: String!
    var schoolYear: Int!
    
    enum CodingKeys: CodingKey {
        case token
        case account
        case parentPhone
        case schoolName
        case schoolYear
    }
    
    init() {
        super.init(url: PGURLs.students)
        self.account = Account()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.token          = try? container.decode(String.self, forKey: .token)
        self.account        = try? container.decode(Account.self, forKey: .account)
        self.parentPhone    = try? container.decode(String.self, forKey: .parentPhone)
        self.schoolName     = try? container.decode(String.self, forKey: .schoolName)
        self.schoolYear     = try? container.decode(Int.self, forKey: .schoolYear)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(token, forKey: .token)
        try? container.encode(account, forKey: .account)
        try? container.encode(parentPhone, forKey: .parentPhone)
        try? container.encode(schoolName, forKey: .schoolName)
        try? container.encode(schoolYear, forKey: .schoolYear)
        
        try super.encode(to: encoder)
    }
    
    override func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        guard let id = self.id else {
            print("Student::patch() -> id is nil.")
            return
        }
        
        let url = PGURLs.students.appendingURL([String(id)])
        
        guard let studentParameter = try? self.toParameter() else {
            print("Student::patch() -> convert account to parameter fail.")
            return
        }
        print(studentParameter)
        
        PGNetwork.patch(url: url, parameter: studentParameter, success: success, fail: fail)
    }
    
    public func getSchoolInfo() -> String {
        return schoolName + " " + String(schoolYear) + "학년"
    }
}
