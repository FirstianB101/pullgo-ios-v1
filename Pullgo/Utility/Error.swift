//
//  Error.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

enum SignInError: Error {
    case NetworkDisconnected
    case InvalidSignIn
    // TEST
    case InvalidIdForTest
}
