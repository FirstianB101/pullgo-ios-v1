//
//  InputUsernameViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class InputUsernameViewController: UIViewController, Styler {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var duplicateCheckButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel = InputUsernameViewModel()
    let animator = AnimationPresentor()

    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
        setTextFieldBorderUnderline(field: usernameTextField)
        setStatusLabel()
        hideUINeeded()
        setKeyboardWatcher()
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: duplicateCheckButton)
        setViewCornerRadius(view: nextButton)
        setViewShadow(view: duplicateCheckButton)
        setViewShadow(view: nextButton)
    }
    
    func hideUINeeded() {
        hide(view: nextButton)
    }
    
    @IBAction func bindingUsername(sender: UITextField) {
        guard let username = sender.text else { return }
        viewModel.username = username
        setStatusLabel()
        animator.slowDisappear(view: nextButton)
    }
    
    func setStatusLabel() {
        statusLabel.text = viewModel.statusLabel
        statusLabel.textColor = viewModel.statusColor
    }
    
    @IBAction func duplicateCheckButtonClicked(sender: UIButton) {
        if viewModel.status != .valid {
            animator.vibrate(view: statusLabel)
            return
        } else if !viewModel.isUnique() {
            let alert = AlertPresentor(presentor: self)
            alert.present(title: "경고", context: "이미 존재하는 아이디입니다.")
            return
        }
        
        animator.slowAppear(view: nextButton)
    }
    
    @IBAction func nextButtonClicked(sender: UIButton) {
        SignUpInformation.shared.account?.username = viewModel.username
    }
}

class InputUsernameViewModel {
    var status: SignUpUsernameStatus = .noInput
    
    var statusLabel: String {
        status.getMessage()
    }
    
    var statusColor: UIColor {
        status.getColor()
    }
    
    private var _username: String = ""
    var username: String {
        get { _username }
        set {
            status = .getStatus(of: newValue)
            _username = newValue
        }
    }
    
    func isUnique() -> Bool {
        // Server API not Exist
        return true
    }
}

enum SignUpUsernameStatus: String, SignUpStatus {
    case tooShort = "아직 5자리가 아니에요."
    case valid = "적절한 아이디입니다!"
    case tooLong = "너무 길어요."
    case invalidChar = "영어(필수), 숫자, -, _로만 만들어주세요."
    case noInput = ""
    
    func getColor() -> UIColor {
        if self == .valid { return .systemGreen }
        else { return .systemPink }
    }
    
    func getMessage() -> String {
        return self.rawValue
    }
    
    static func getStatus(of username: String) -> SignUpUsernameStatus {
        if username.isUsernameValid { return .valid }
        else if username.isEmpty { return .noInput }
        else if username.count < 5 { return .tooShort }
        else if username.count > 16 { return .tooLong }
        else { return .invalidChar }
    }
}

extension String {
    var isUsernameValid: Bool {
        let usernameRegEx = "^(?=.*[a-z])[a-z0-9]{1}[a-z0-9-_]{4,16}$"
        return self.predicate(regex: usernameRegEx)
    }
}
