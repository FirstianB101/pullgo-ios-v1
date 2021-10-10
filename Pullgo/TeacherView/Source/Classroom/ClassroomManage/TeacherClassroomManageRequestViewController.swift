//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit
import XLPagerTabStrip

class TeacherClassroomManageRequestViewController: ButtonBarPagerTabStripViewController, TeacherClassroomManageTopBar {
    
    override func viewDidLoad() {
        self.setDefaultSettings()
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let teacherVC = storyboard?.instantiateViewController(withIdentifier: "ClassroomAcceptTeacherViewController"),
              let studentVC = storyboard?.instantiateViewController(withIdentifier: "ClassroomAcceptStudentViewController") else { return [] }
        
        return [teacherVC, studentVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "요청 관리"
    }
}
