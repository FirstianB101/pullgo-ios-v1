//
//  Question.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import UIKit

class Question: PGNetworkable {
    
    var questionNumber: Int?
    var picture: UIImage?
    
    var answer: [Int]!
    var choice: [String : String]!
    var pictureUrl: String!
    var content: String!
    var examId: Int!
    
    enum CodingKeys: CodingKey {
        case answer, choice, pictureUrl, content, examId
    }
    
    init() {
        super.init(url: PGURLs.questions)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.answer     = try? container.decode([Int].self, forKey: .answer)
        self.choice     = try? container.decode([String : String].self, forKey: .choice)
        self.pictureUrl = try? container.decode(String.self, forKey: .pictureUrl)
        self.content    = try? container.decode(String.self, forKey: .content)
        self.examId     = try? container.decode(Int.self, forKey: .examId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.answer, forKey: .answer)
        try? container.encode(self.choice, forKey: .choice)
        try? container.encode(self.pictureUrl, forKey: .pictureUrl)
        try? container.encode(self.content, forKey: .content)
        try? container.encode(self.examId, forKey: .examId)
        
        try super.encode(to: encoder)
    }
}
