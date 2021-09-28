//
//  Question.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Question: PGNetworkable {
    
    var answer: [Int]!
    var pictureUrl: String!
    var content: String!
    var examId: Int!
    
    init() {
        super.init(url: PGURLs.questions)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
