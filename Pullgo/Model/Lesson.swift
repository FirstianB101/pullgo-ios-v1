//
//  Lesson.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Lesson: PGNetworkable {
    
    var classroomId: Int!
    var academyId: Int!
    var name: String!
    var schedule: Schedule!
    
    enum CodingKeys: CodingKey {
        case id, classroomId, name, schedule
    }
    
}

extension Lesson {
    private var lessonId: String {
        guard let lessonId = self.id else {
            fatalError("Lesson::id -> id is nil.")
        }
        return String(lessonId)
    }
    
    public func getBelongedAcademy(completion: @escaping ((Academy) -> Void)) {
        guard let academyId = self.academyId else {
            return
        }
        let url = PGURLs.academies.appendingURL([String(academyId)])
        
        PGNetwork.get(url: url, type: Academy.self, success: completion)
    }
}
