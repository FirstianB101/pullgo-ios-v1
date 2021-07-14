//
//  Lesson.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

struct Lesson: Codable {
    var id: Int?
    var classroomId: Int?
    var name: String?
    var schedule: Schedule?
}
