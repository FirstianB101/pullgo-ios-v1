//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

protocol TeacherClassroomManageTopBar {
    var classroomName: UILabel! { get set }
    func setPromptNameBySelectedClassroom()
    func dismissSelectedClassroom()
    func backButtonClicked(_ sedner: UIBarButtonItem)
}

extension TeacherClassroomManageTopBar {
    func dismissSelectedClassroom() {
        TeacherClassroomManageViewModel.selectedClassroom = nil
    }
}

class TeacherClassroomManageExamViewController: UIViewController, TeacherClassroomManageTopBar {
    @IBOutlet weak var classroomName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setPromptNameBySelectedClassroom()
    }
    
    func setPromptNameBySelectedClassroom() {
        classroomName.text = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismissSelectedClassroom()
        self.dismiss(animated: true, completion: nil)
    }
}
