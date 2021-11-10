//
//  ContainerViewFactory.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit

protocol ContainerView: UIView {
    init(question: Question?)
}

class ContainerViewFactory {
    
    public static func getContainerView(of type: ExamType, question: Question?) -> ContainerView {
        
        switch type {
            case .create:
                return CreateContainerView(question: question)
            case .history:
                return HistoryContainerView(question: question)
            case .take:
                return TakeContainerView(question: question)
        }
    }
}
