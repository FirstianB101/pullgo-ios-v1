//
//  UserType.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

enum UserType: Int {
    case Student = 0
    case Teacher = 1
    
    static func ToUserType(index: Int) -> UserType? {
        if index == 0 {
            return .Student
        } else if index == 1 {
            return .Teacher
        }
        
        return nil
    }
    
    func ToURLComponent() -> String {
        if self == .Student {
            return "students"
        } else {
            return "teachers"
        }
    }
}
