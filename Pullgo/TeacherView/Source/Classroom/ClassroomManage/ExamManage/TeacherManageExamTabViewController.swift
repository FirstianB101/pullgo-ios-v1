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
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "TeacherExamEditViewController") as? TeacherExamEditViewController,
              let removeVC = storyboard?.instantiateViewController(withIdentifier: "TeacherRemoveExamViewController") as? TeacherRemoveExamViewController else { return [] }
        
        return [editVC, removeVC]
    }

    override func viewDidLoad() {
        self.setDefaultSettings()
        super.viewDidLoad()
    }

}

class TeacherManageExamViewModel {
    var selectedExam: Exam!
    
}
