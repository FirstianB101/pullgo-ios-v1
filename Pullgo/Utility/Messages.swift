//
//  Messages.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

enum Message: String {
    case NetworkError = "오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
}

enum plistKeys: String {
    case AutoLoginKey = "autoLoginStatus"
    case userTypeKey = "userType"
    case userIdKey = "userId"
}
