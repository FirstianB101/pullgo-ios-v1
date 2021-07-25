//
//  TeacherClassroomDetailSegue.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/20.
//

import UIKit

class TeacherClassroomDetailSegue: UIStoryboardSegue {
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
        
    override func perform() {
        source.present(destination, animated: true, completion: nil)
    }
}
