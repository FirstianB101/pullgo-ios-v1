//
//  ContainerViewFactory.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit

protocol ContainerView: UIView {
    init(question: Question?, target: UIViewController)
}

class ContainerViewFactory {
    
    public static func getContainerView(of type: ExamType, question: Question?, target: UIViewController) -> ContainerView {
        
        switch type {
            case .create:
                return CreateQuestionContainer(question: question, target: target)
            case .history:
                return HistoryContainerView(question: question, target: target)
            case .take:
                return TakeContainerView(question: question, target: target)
        }
    }
}
