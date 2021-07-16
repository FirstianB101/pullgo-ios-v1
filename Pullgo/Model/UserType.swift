//
//  UserType.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

enum UserType: Int {
    case student = 0
    case teacher = 1
    
    static func ToUserType(index: Int) -> UserType? {
        if index == 0 {
            return .student
        } else if index == 1 {
            return .teacher
        }
        
        return nil
    }
    
    func ToURLComponent() -> String {
        if self == .student {
            return "students"
        } else {
            return "teachers"
        }
    }
    
    func toURLQuery() -> String {
        if self == .student {
            return "studentId"
        } else {
            return "teacherId"
        }
    }
}
