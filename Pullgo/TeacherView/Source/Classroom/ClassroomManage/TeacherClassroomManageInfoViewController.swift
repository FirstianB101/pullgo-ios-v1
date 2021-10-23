//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.

import UIKit
import XLPagerTabStrip

class TeacherClassroomManageInfoViewController: ButtonBarPagerTabStripViewController, TeacherClassroomManageTopBar {
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        guard let changeInfo = storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomChangeInfoViewController"),
              let remove = storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomRemoveViewController") else { return [] }
        
        return [changeInfo, remove]
    }

    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "반 수정 및 삭제"
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    override func viewDidLoad() {
        self.setDefaultSettings()
        
        super.viewDidLoad()

        setTitleByTabBarMenu()
        setPromptNameBySelectedClassroom()
    }
    
}
