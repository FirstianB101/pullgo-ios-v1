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
    
    func requestSignIn() {
        let url: URL = getUserInfoURL()
        let success: (() -> (Void))? = nil
        let fail: (() throws -> (Void))? = { throw SignInError.InvalidSignIn }
        
        let userInfo = AF.request(url)
        userInfo.responseJSON() { response in
            print("\(try! response.result.get())")
            success?()
        }
    }
    
    func getUserInfoURL() -> URL {
        return NetworkManager.assembleURL(components: [self.userType.ToURLComponent(),
                                                       String(self.id)])
    }
}
