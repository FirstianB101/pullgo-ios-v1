//
//  TeacherManageExamTabViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/23.
//

import UIKit
import XLPagerTabStrip

class TeacherManageExamTabViewController: ButtonBarPagerTabStripViewController {
    
    let viewModel = TeacherManageExamViewModel()
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let editVC = storyboard?.instantiateViewController(identifier: "TeacherExamEditViewController", creator: { coder in
            return TeacherExamEditViewController(coder: coder, viewModel: self.viewModel)
        }),
              let removeVC = storyboard?.instantiateViewController(identifier: "TeacherRemoveExamViewController", creator: { coder in
                  return TeacherRemoveExamViewController(coder: coder, viewModel: self.viewModel)
              })  else { return [] }
        
        return [editVC, removeVC]
    }
    
    override func viewDidLoad() {
        self.setDefaultSettings()
        super.viewDidLoad()
    }
    
}

class TeacherManageExamViewModel {
    var selectedExam: Exam!
    
    var name: String {
        get { selectedExam.name }
        set { selectedExam.name = newValue }
    }
    
    var passScore: Int {
        get { selectedExam.passScore }
        set { selectedExam.passScore = newValue }
    }
    
    var beginDateTime: Date {
        get { selectedExam.beginDateTime.toISO8601 }
        set { selectedExam.beginDateTime = newValue.toString(format: "YYYY-MM-ddTHH:mm:00") }
    }
    
    var endDateTime: Date {
        get { selectedExam.endDateTime.toISO8601 }
        set { selectedExam.endDateTime = newValue.toString(format: "YYYY-MM-ddTHH:mm:00") }
    }
    
    var timeLimit: Date {
        get { selectedExam.timeLimit.toISO8601 }
        set {
            let hour = newValue.toString(format: "H")
            let minute = newValue.toString(format: "m")
            selectedExam.timeLimit = "PT\(hour)H\(minute)M"
        }
    }
    
    public func patchExam(completion: @escaping ((Data?) -> Void)) {
        selectedExam.patch(success: completion)
    }
}
