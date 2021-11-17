//
//  Question.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import UIKit

class Question: PGNetworkable, Equatable {
    
    var questionNumber: Int?
    var picture: UIImage?
    
    var answer: [Int]! = []
    var choice: [String : String]! = ["1" : "",
                                      "2" : "",
                                      "3" : "",
                                      "4" : "",
                                      "5" : ""]
    var pictureUrl: String! = ""
    var content: String! = ""
    var examId: Int!
    
    enum CodingKeys: CodingKey {
        case answer, choice, pictureUrl, content, examId
    }
    
    init() {
        super.init(url: PGURLs.questions)
    }
    
    deinit {
        picture = nil
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
    
    // MARK: - Equatable
    public static func ==(lhs: Question, rhs: Question) -> Bool {
        return (lhs.questionNumber == rhs.questionNumber &&
                lhs.content == rhs.content &&
                lhs.answer == rhs.answer &&
                lhs.examId == rhs.examId &&
                lhs.choice == rhs.choice)
    }
    
    // MARK: - Methods
    override func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        let question = Question()
        
        guard let id = self.id else {
            fatalError("Question::patch() -> id is nil.")
        }
        question.answer = self.answer
        question.choice = self.choice
        question.pictureUrl = self.pictureUrl
        question.content = self.content
        
        let url = PGURLs.questions.appendingURL([String(id)])
        guard let parameter = try? question.toParameter() else {
            fatalError("Question::patch() -> question to parameter failed.")
        }
        
        PGNetwork.patch(url: url, parameter: parameter, success: success, fail: fail)
    }
    
    func getChoice(of index: String) -> String {
        return self.choice[index]!
    }
    
    func getImage() {
        guard let url = URL(string: self.pictureUrl) else {
            print("\(self)::Incorrect Url.")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            print("\(self)::Cannot load data from url(\(url)).")
            return
        }
        self.picture = UIImage(data: data)
    }
}
