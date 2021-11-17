//
//  EditChoiceView.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/13.
//

import UIKit

class TakeExamChoiceView: ChoiceView {

    override init(examType: ExamType, viewModel: ExamViewModel) {
        super.init(examType: examType, viewModel: viewModel)
        
        appendChoice()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendChoice() {
        for i in 1 ... 5 {
            let choice = PGChoiceView(number: i, state: .normal, examType: examType, viewModel: viewModel)
            
            super.appendChoice(choice)
        }
    }
}
