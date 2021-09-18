//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

class Account: Codable {
    var username: String!
    var fullName: String!
    var phone: String!
}

let PGSignedUser = _PGSignedUser.default
class _PGSignedUser {
    public static let `default` = _PGSignedUser()
    
    var userType: UserType!
    var student: Student!
    var teacher: Teacher!
}
