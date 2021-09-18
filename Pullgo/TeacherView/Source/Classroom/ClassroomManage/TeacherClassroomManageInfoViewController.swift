//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.

import UIKit

class TeacherClassroomManageInfoViewController: UIViewController, TeacherClassroomManageTopBar {

    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "반 수정 및 삭제"
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitleByTabBarMenu()
        setPromptNameBySelectedClassroom()
        
    }
    
}
