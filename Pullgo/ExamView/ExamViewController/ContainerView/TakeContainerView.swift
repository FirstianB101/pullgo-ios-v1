//
//  HistoryContainerView.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit

class TakeContainerView: UIView, ContainerView {
    
    required init(question: Question?, target: UIViewController) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
