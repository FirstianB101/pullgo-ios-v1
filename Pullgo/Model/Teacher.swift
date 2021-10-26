//
//  Teacher.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

class Teacher: PGNetworkable {
    
    var token: String?
    var account: Account!
    
    enum CodingKeys: CodingKey {
        case token
        case account
    }
    
    init() {
        super.init(url: PGURLs.teachers)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try? container.decode(String.self, forKey: .token)
        self.account = try? container.decode(Account.self, forKey: .account)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(token, forKey: .token)
        try? container.encode(account, forKey: .account)
        
        try super.encode(to: encoder)
    }
    
    public override func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        guard let id = self.id else {
            print("Teacher::patch() -> id is nil.")
            return
        }
        let url = PGURLs.teachers.appendingURL([String(id)])
        
        guard let accountParameter = try? account.toParameter() else {
            print("Teacher::patch() -> convert account to parameter fail.")
            return
        }
        
        let account: Parameter = ["account" : accountParameter]
        
        print("DEBUG: ")
        print(account)
        PGNetwork.patch(url: url, parameter: account, success: success, fail: fail)
    }
}
