//
//  ExamPagableViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import Foundation
import RxSwift
import RxCocoa

protocol ExamPagableViewModel {
    
    var currentQuestion: Question? { get set }
    var questions: [Question] { get set }
    var selectedExam: Exam { get }
    var isFirstQuestion: Bool { get }
    var isLastQuestion: Bool { get }
    var currentQuestionSubject: BehaviorSubject<Question?> { get }
    
    func hasQuestionNumber(_ number: Int) -> Bool
    func setCurrentQuestion(to number: Int)
}
