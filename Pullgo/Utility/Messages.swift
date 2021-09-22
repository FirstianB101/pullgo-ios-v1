//
//  Messages.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

enum Message: String {
    case networkError = "서버와 통신 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
    case unknownError = "오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
    case signInFail = "아이디 혹은 비밀번호가 일치하지 않습니다."
}

enum plistKeys: String {
    case AutoLoginKey = "autoLoginStatus"
    case userTypeKey = "userType"
    case userIdKey = "userId"
}
