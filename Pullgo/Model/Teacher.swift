//
//  Teacher.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

class Teacher: PGNetworkable {
    
    var token: String!
    var account: Account!
    
    enum CodingKeys: CodingKey {
        case account
    }
    
    init() {
        super.init(url: PGURLs.teachers)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
