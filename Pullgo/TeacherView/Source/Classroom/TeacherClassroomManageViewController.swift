//
//  TeacherClassroomManageViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/16.
//

import UIKit

class TeacherClassroomManageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }
    
    @IBAction func addClassroom(_ sender: UIBarButtonItem) {
        
    }
}
