//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire

struct Account: Codable {
    let username: String
    let password: String?
    let fullName: String
    let phone: String
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
            // ?
        }
    }
    
    func getUserInfoURL() -> URL {
        var url: URL = ServerInfo.url
        
        url.appendPathComponent(self.userType.ToURLComponent())
        url.appendPathComponent(String(self.id))
        
        return url
    }
}
