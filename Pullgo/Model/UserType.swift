//
//  UserType.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation

enum UserType: String {
    case student = "student"
    case teacher = "teacher"
    
    static func toUserType(index: Int) -> UserType? {
        if index == 0 {
            return .student
        } else if index == 1 {
            return .teacher
        }
        
        return nil
    }
    
    public func toURLComponent() -> String {
        return self.rawValue.appending("s")
    }
    
    public func toUserTypeId() -> String {
        return self.rawValue.appending("Id")
    }
    
    public func toApplyingUserTypeId() -> String {
        return "applying" + self.rawValue.capitalized + "Id"
    }
    
    public func toAcceptComponent() -> String {
        return "accept-\(self.rawValue)"
    }
    
    public func toKickComponent() -> String {
        return "kick-\(self.rawValue)"
    }
    
    public func toParameter(userId: Int) -> Parameter {
        return [self.toUserTypeId() : String(userId)]
    }
}
