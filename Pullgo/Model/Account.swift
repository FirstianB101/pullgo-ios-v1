//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire

struct Account: Codable {
    var username: String!
    var password: String?
    var fullName: String!
    var phone: String!
}

struct SignedUserInfo {
    static var shared: SignedUserInfo = SignedUserInfo()
    
    var id: Int!
    var student: Student!
    var teacher: Teacher!
    var userType: UserType!
    
    mutating func setUserInfo(id: Int, type: UserType) {
        self.id = id
        self.userType = type
    }
    
    func requestSignIn(success: @escaping ((Data?) -> ()), fail: @escaping (() -> ())) {
        let url: URL = getUserInfoURL()
        NetworkManager.get(url: url, success: success, fail: fail)
    }
    
    func getUserInfoURL() -> URL {
        return NetworkManager.assembleURL(components: [self.userType.ToURLComponent(),
                                                       String(self.id)])
    }
}
