//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire
import UIKit

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
    
    var academies: [Academy]? = nil
    var signedAcademy: Academy? = nil
    
    mutating func setUserInfo(id: Int, type: UserType) {
        self.id = id
        self.userType = type
    }
    
    func requestSignIn(success: @escaping ((Data?) -> ()), fail: @escaping (() -> ())) {
        let url: URL = getUserInfoURL()
        NetworkManager.get(url: url, success: success, fail: fail) {
            self.getAcademyInfo()
        }
    }
    
    func getUserInfoURL() -> URL {
        return NetworkManager.assembleURL(components: [self.userType.ToURLComponent(), String(self.id)])
    }
    
    func getAcademyInfo() {
        var url: URL = NetworkManager.assembleURL(components: ["academies"])
        url.appendQuery(query: URLQueryItem(name: self.userType.toURLQuery(), value: String(self.id)))
        
        NetworkManager.get(url: url, success: { data in
            guard let academies = try! data?.toObject(type: [Academy].self) else {
                print("SignedUserInfo.getAcademyInfo() -> toObject error")
                return
            }
            
            SignedUserInfo.shared.academies = academies
            if academies.isEmpty { SignedUserInfo.shared.signedAcademy = nil }
            else { SignedUserInfo.shared.signedAcademy = academies[1] }
        }, fail: {
            print("SignedUserInfo.getAcademyInfo() -> Response error")
        })
    }
}
