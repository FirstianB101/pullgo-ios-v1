//
//  Lesson.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/11.
//

import Foundation

class Lesson: Codable {
    var id: Int?
    var classroomId: Int?
    var name: String?
    var schedule: Schedule?
    
    var belongAcademy: Academy?
    
    init(id: Int?, classroomId: Int?, name: String?, schedule: Schedule?) {
        self.id = id
        self.classroomId = classroomId
        self.name = name
        self.schedule = schedule
    }
    
    func getBelongAcademyInfo() {
        self.getBelongClassroomById() { classroom in
            let url = NetworkManager.assembleURL("academies", "\(classroom.id!)")
            let success: ResponseClosure = { data in
                guard let receivedAcademy = try? data?.toObject(type: Academy.self) else {
                    fatalError("Lesson.getBelongAcademyInfo() -> data parse error")
                }
                self.belongAcademy = receivedAcademy
            }
            
            NetworkManager.get(url: url, success: success)
        }
    }
    
    private func getBelongClassroomById(complete: @escaping ((Classroom) -> ())) {
        let url = NetworkManager.assembleURL("academy", "classrooms", "\(self.classroomId!)")
        let success: ResponseClosure = { data in
            guard let receivedClassroom = try? data?.toObject(type: Classroom.self) else {
                fatalError("Lesson.getBelongClassroomById() -> data parse error")
            }
            complete(receivedClassroom)
        }
        
        NetworkManager.get(url: url, success: success)
    }
}
