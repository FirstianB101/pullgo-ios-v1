//
//  Classroom.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

struct Classroom: Codable {
    var id: Int?
    var name: String?
    var creatorId: Int!
    var academyId: Int!
    
    static func == (lhs: Classroom, rhs: Classroom) -> Bool {
        return (
            rhs.id == lhs.id &&
            rhs.name == lhs.name &&
            rhs.creatorId == lhs.creatorId &&
            rhs.academyId == lhs.academyId
        )
    }
}
