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

let SignedUser = SignedUserInfo.default

class SignedUserInfo {
    static let `default`: SignedUserInfo = SignedUserInfo()
    
    var id: Int!
    var student: Student!
    var teacher: Teacher!
    var userType: UserType!
    
    var academies: [Academy]? = nil
    var signedAcademy: Academy? = nil
    var classrooms: [Classroom]? = nil
    var networkFailDelegate: NetworkFailDelegate?
    
    func setUserInfo(id: Int, type: UserType) {
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
            
            SignedUser.academies = academies
            if academies.isEmpty { SignedUser.signedAcademy = nil }
            else { SignedUser.signedAcademy = academies[0] }
        }, fail: {
            print("SignedUserInfo.getAcademyInfo() -> Response error")
        })
    }
    
    func getClassroomInfo(complete: @escaping (() -> ())) {
        var url: URL = NetworkManager.assembleURL(components: ["academy", "classrooms"])
        url.appendQuery(queryItems: getQueryItems())
        
        let success: ((Data?) -> ()) = { data in
            guard let classrooms = try? data?.toObject(type: [Classroom].self) else {
                print("SignedUserInfo.getClassroomData() -> data parse error")
                return
            }
            SignedUser.classrooms = classrooms
        }
        
        let fail: (() -> ()) = {
            SignedUser.networkFailDelegate?.networkFailAlert()
        }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    private func getQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        guard let teacherId = SignedUser.teacher.id else { return [] }
        guard let academyId = SignedUser.signedAcademy?.id else { return [] }
        
        items.append(URLQueryItem(name: "teacherId", value: String(teacherId)))
        items.append(URLQueryItem(name: "academyId", value: String(academyId)))
        return items
    }
}
