//
//  SignUpInformation.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import Foundation
import Alamofire

struct SignUpInformation {
    static var shared = SignUpInformation()
    
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
    
    func postSignUpInformation(success: ResponseClosure? = nil, fail: FailClosure? = nil) {
        let url = NetworkManager.assembleURL(SignUpInformation.shared.userType.toURLComponent())
        
        if SignUpInformation.shared.userType == .student {
            let student = SignUpInformation.shared.student
            NetworkManager.post(url: url, data: student, success: success, fail: fail)
        } else {
            let teacher = SignUpInformation.shared.teacher
            NetworkManager.post(url: url, data: teacher, success: success, fail: fail)
        }
    }
}
