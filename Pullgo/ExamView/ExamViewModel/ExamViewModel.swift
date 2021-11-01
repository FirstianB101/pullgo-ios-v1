//
//  ExamViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import Foundation

class ExamViewModel {
    
    var exam: Exam
    var questions = [Question]()
    
    init(exam: Exam) {
        self.exam = exam
        getQuestions()
    }
    
    private func getQuestions() {
        exam.getQuestions(page: 0) { questions in
            self.questions = questions
        }
    }
}
