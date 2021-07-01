//
//  InputUsernameViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class InputUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var idStatusLabel: UILabel!
    @IBOutlet weak var duplicateCheckButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let animator = AnimationPresentor()
    var status: SignUpUsernameStatus = .invalidChar

    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
        hide(view: idStatusLabel)
    }
    
    func setButtonUI() {
        Styler.setDefaultButtonStyle(button: duplicateCheckButton)
        Styler.setDefaultButtonStyle(button: nextButton)
        hide(view: nextButton)
    }
    
    func hide(view: UIView) {
        view.alpha = 0
    }
    
    func show(view: UIView) {
        view.alpha = 1
    }
    
    @IBAction func usernameInputListener(sender: UITextField) {
        guard let usernameInput = sender.text else { return }
        
        show(view: idStatusLabel)
        status = .getStatus(username: usernameInput)
        setStatusLabel(username: usernameInput)
    }
    
    func setStatusLabel(username: String) {
        idStatusLabel.text = status.getMessage()
        idStatusLabel.textColor = status.getColor()
    }
    
    @IBAction func duplicateCheckButtonPressed(sender: UIButton) {
        if !isValidUsername() {
            vibrateStatusLabel()
        } else if !isUniqueUsername() {
            showAlert()
        }
        
        animator.slowAppear(view: nextButton)
        print("asd")
    }
    
    func isValidUsername() -> Bool {
        if status == .valid { return true }
        else { return false }
    }
    
    func vibrateStatusLabel() {
        animator.vibrate(view: idStatusLabel)
    }
    
    func isUniqueUsername() -> Bool {
        // guard let usernameInput = usernameTextField.text else { return }
        // check duplicate
        // API not exist
        return true
    }
    
    func showAlert() {
        let alert = AlertPresentor(view: self)
        alert.present(title: "경고", context: "이미 존재하는 아이디입니다.")
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        print("next")
    }
}

enum SignUpUsernameStatus: String {
    case tooShort = "아직 5자리가 아니에요."
    case valid = "적절한 아이디입니다!"
    case tooLong = "너무 길어요."
    case invalidChar = "영어(필수), 숫자, -, _로만 만들어주세요."
    
    func getColor() -> UIColor {
        if self == .valid { return .systemGreen }
        else { return .red }
    }
    
    func getMessage() -> String {
        return self.rawValue
    }
    
    static func getStatus(username: String) -> SignUpUsernameStatus {
        let length = username.count
        
        if isUsernameValid(username: username) { return .valid }
        else if length < 5 { return .tooShort }
        else if length > 16 { return .tooLong }
        else { return .invalidChar }
    }
    
    static func isUsernameValid(username: String) -> Bool {
        let usernameRegEx = "^[a-z0-9]{1}[a-z0-9-_]{4,16}$"
        return username.predicate(regex: usernameRegEx)
    }
}

