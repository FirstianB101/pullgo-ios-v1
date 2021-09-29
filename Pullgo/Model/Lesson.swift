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
        case academyId, classroomId, name, schedule
    }
    
    init() {
        super.init(url: PGURLs.lessons)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.classroomId    = try? container.decode(Int.self, forKey: .name)
        self.academyId      = try? container.decode(Int.self, forKey: .academyId)
        self.name           = try? container.decode(String.self, forKey: .name)
        self.schedule       = try? container.decode(Schedule.self, forKey: .schedule)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.classroomId, forKey: .name)
        try? container.encode(self.academyId, forKey: .academyId)
        try? container.encode(self.name, forKey: .name)
        try? container.encode(self.schedule, forKey: .schedule)
        
        try super.encode(to: encoder)
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
