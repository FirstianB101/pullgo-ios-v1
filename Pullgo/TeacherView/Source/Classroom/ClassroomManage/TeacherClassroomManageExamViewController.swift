//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

protocol TeacherClassroomManageTopBar {
    func setPromptNameBySelectedClassroom()
    func dismissSelectedClassroom()
    func setTitleByTabBarMenu()
}

extension TeacherClassroomManageTopBar {
    func dismissSelectedClassroom() {
        TeacherClassroomManageViewModel.selectedClassroom = nil
    }
}

class TeacherClassroomManageExamViewController: UIViewController, TeacherClassroomManageTopBar {
    let viewModel = TeacherClassroomManageExamViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.getExams {
            
        }
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "시험 관리"
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
}

class TeacherClassroomManageExamViewModel {
    var exams = [Exam]()
    
    func getExams(complete: @escaping EmptyClosure) {
        TeacherClassroomManageViewModel.selectedClassroom.getExams() {
            self.exams = TeacherClassroomManageViewModel.selectedClassroom.exams
            complete()
        }
    }
}
