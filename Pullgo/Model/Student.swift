//
//  Student.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

struct Student: Codable {
    var id: Int? = nil
    var account: Account! = nil
    var parentPhone: String! = nil
    var schoolName: String! = nil
    var schoolYear: Int! = nil
}
