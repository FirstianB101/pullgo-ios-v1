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
    
    var currentQuestionSubject: BehaviorSubject<Question?> = BehaviorSubject<Question?>(value: nil)
    var currentQuestion: Question? {
        didSet {
            currentQuestionSubject.onNext(currentQuestion)
        }
    }
    var selectedExam: Exam
    var questions = [Question]()
    
    public var isFirstQuestion: Bool { questions.first == currentQuestion }
    public var isLastQuestion: Bool { questions.last == currentQuestion }
    
    init(exam: Exam) {
        self.selectedExam = exam
    }
    
    private func getQuestions() {
        selectedExam.getQuestions(page: 0) { questions in
            self.questions = questions
            self.currentQuestion = questions.first
        }
    }
    
    func hasQuestionNumber(_ number: Int) -> Bool {
        return !questions.filter { $0.questionNumber == number }.isEmpty
    }
    
    func setCurrentQuestion(to number: Int) {
        for question in questions {
            if question.questionNumber == number {
                currentQuestion = question
                return
            }
        }
    }
}
