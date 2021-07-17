//
//  TeacherRequestClassroomJoinViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/17.
//

import UIKit

class TeacherRequestClassroomJoinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKeyboard()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }

}
