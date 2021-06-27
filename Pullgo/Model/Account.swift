//
//  Account.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

struct Account: Codable {
    let username: String
    let password: String?
    let fullName: String
    let phone: String
}
