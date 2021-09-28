//
//  Student.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//
import Foundation

class Student: PGNetworkable {
    
    var token: String!
    var account: Account!
    var parentPhone: String!
    var schoolName: String!
    var schoolYear: Int!
    
    init() {
        super.init(url: PGURLs.students)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
