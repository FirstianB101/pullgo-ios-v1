//
//  SignUpViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class SignUpViewController: UIViewController, Styler {

    @IBOutlet weak var signUpStudentButton: UIButton!
    @IBOutlet weak var signUpTeacherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
    }
    
    func setButtonUI() {
        setDefaultButtonStyle(button: signUpStudentButton)
        setDefaultButtonStyle(button: signUpTeacherButton)
    }
    
    @IBAction func studentClicked(sender: UIButton) {
        SignUpInformation.shared.userType = .Student
    }
    
    @IBAction func teacherClicked(sender: UIButton) {
        SignUpInformation.shared.userType = .Teacher
    }
}
