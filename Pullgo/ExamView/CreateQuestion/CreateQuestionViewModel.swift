//
//  CreateQuestionViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/01.
//

import Foundation
import RxSwift
import RxCocoa

class CreateQuestionViewModel: ExamViewModel {
    
//  var currentQuestion: Question?
//  var selectedExam: Exam
//  var questions = [Question]()
    
    public func setTimeLimit(_ timeLimit: Date) {
        let splitTimeLimit = timeLimit.toString(format: "H:m").split(separator: ":")
        let hour = splitTimeLimit[0]
        let minute = splitTimeLimit[1]
        
        var result = "PT"
        if hour != "0" { result += "\(hour)H" }
        if minute != "0" { result += "\(minute)M" }
        
        self.selectedExam.timeLimit = result
    }
    
    public func saveQuestions(completion: @escaping (() -> Void)) {
        let dispatchGroup = DispatchGroup()
        
        for question in questions {
            dispatchGroup.enter()
            
            if question.id == nil {
                question.post(success: { d in
                    guard let received = try? d?.toObject(type: Question.self) else {
                        fatalError("CreateQuestionViewModel::saveQuestions() -> convert data fail.")
                    }
                    question.id = received.id
                    dispatchGroup.leave()
                })
            } else {
                question.patch(success: { _ in
                    dispatchGroup.leave()
                })
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func saveQuestion(completion: @escaping (() -> Void)) {
        
    }
}
