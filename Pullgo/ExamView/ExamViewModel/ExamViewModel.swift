//
//  ExamViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import UIKit
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
        getQuestions()
    }
    
    private func getQuestions() {
        selectedExam.getQuestions(page: 0) { questions in
            self.questions = questions
            
            if questions.isEmpty {
                self.createQuestion()
            } else {
                self.currentQuestion = questions.first
            }
        }
    }
    
    public func createQuestion() {
        let newQuestion = self.getNewQuestion()
        
        self.questions.append(newQuestion)
        
        self.setCurrentQuestion(to: newQuestion.questionNumber!)
    }
    
    func getNewQuestion() -> Question {
        let question = Question()
        
        question.examId = self.selectedExam.id!
        question.questionNumber = (questions.last?.questionNumber ?? 0) + 1
        
        return question
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
    
    private func removeAnswer(_ answer: Int) {
        for (index, value) in self.currentQuestion!.answer.enumerated() {
            if value == answer {
                self.currentQuestion!.answer.remove(at: index)
                break
            }
        }
    }
    
    @objc
    func toggleIsAnswer(_ sender: UIButton) {
        let number = sender.tag
        
        if self.currentQuestion!.answer.contains(number) {
            sender.isSelected = false
            removeAnswer(number)
        } else {
            sender.isSelected = true
            self.currentQuestion!.answer.append(number)
        }
    }
}
