//
//  SignUpEnumProtocol.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import UIKit

protocol SignUpStatus {
    func getColor() -> UIColor
    func getMessage() -> String
    static func getStatus(of input: String) -> Self
}
