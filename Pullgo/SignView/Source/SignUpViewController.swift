//
//  SignUpViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpStudentButton: PGButton!
    @IBOutlet weak var signUpTeacherButton: PGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func studentClicked(sender: UIButton) {
        SignUpInformation.shared.userType = .student
    }
    
    @IBAction func teacherClicked(sender: UIButton) {
        SignUpInformation.shared.userType = .teacher
    }
}
