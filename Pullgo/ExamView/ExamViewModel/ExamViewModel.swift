//
//  ExamViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import Foundation
import RxSwift
import RxCocoa

class ExamViewModel: ExamPagableViewModel {
    var currentQuestion: Question?
    var selectedExam: Exam
    var questions = [Question]()
    
    init(exam: Exam) {
        self.selectedExam = exam
//        getQuestions()
        
    }
    
    private func getQuestions() {
        selectedExam.getQuestions(page: 0) { questions in
            self.questions = questions
            self.currentQuestion = questions.first
        }
    }
    
    public func hasQuestionNumber(_ number: Int) -> Bool {
        return !questions.filter { $0.questionNumber == number }.isEmpty
    }
}
