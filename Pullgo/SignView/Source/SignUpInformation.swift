//
//  SignUpInformation.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import Foundation
import Alamofire

class SignUpInformation {
    static let shared = SignUpInformation()
    
    var student: Student?
    var teacher: Teacher?
    var account: Account?
    
    private var _userType: UserType = .student
    var userType: UserType {
        get { _userType }
        set {
            _userType = newValue
            if newValue == .student {
                student = Student()
                teacher = nil
            } else {
                teacher = Teacher()
                student = nil
            }
            account = Account()
        }
    }
    
    func mergeAccount() {
        let account = SignUpInformation.shared.account
        
        if SignUpInformation.shared.userType == .student {
            SignUpInformation.shared.student?.account = account
        } else {
            SignUpInformation.shared.teacher?.account = account
        }
    }
}
