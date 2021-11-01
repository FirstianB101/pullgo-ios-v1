//
//  CreateQuestionViewModel.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/01.
//

import Foundation

class CreateQuestionViewModel: ExamPagableViewModel {
    
    var currentQuestion: Question
    var questions: [Question]
    var selectedExam: Exam
    
    init() {
        currentQuestion = Question()
        questions = []
        selectedExam = Exam()
    }
}
