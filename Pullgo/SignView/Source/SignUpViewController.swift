//
//  SignUpViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpStudentButton: UIButton!
    @IBOutlet weak var signUpTeacherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
    }
    
    func setButtonUI() {
        Styler.setDefaultButtonStyle(button: signUpStudentButton)
        Styler.setDefaultButtonStyle(button: signUpTeacherButton)
    }
}
