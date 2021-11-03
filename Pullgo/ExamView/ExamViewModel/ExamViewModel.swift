//
//  ExamViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import Foundation

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
    
    public func getQuestion(at questionNumber: Int) -> Question? {
        if !(0 ..< questions.count).contains(questionNumber) {
            let alert = PGAlertPresentor()
            alert.present(title: "오류", context: "Index out of range.")
            return nil
        }
        
        return questions[questionNumber]
    }
}
