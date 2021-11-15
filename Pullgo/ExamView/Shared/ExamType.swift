//
//  ExamType.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import Foundation

enum ExamType {
    case create
    case take
    case history
    
    func getChoiceViewTitle() -> String {
        switch self {
            case .create:
                return "보기 작성"
            case .history:
                return "정답 확인"
            case .take:
                return "정답 체크"
        }
    }
}
