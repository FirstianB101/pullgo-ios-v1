//
//  Student.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

struct Student: Codable {
    let id: Int?
    let account: Account
    let parentPhone: String
    let schoolName: String
    let schoolYear: Int
}
