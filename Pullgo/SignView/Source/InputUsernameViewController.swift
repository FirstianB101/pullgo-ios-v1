//
//  InputUsernameViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit
import RxCocoa

class InputUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: PGTextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var duplicateCheckButton: PGButton!
    @IBOutlet weak var nextButton: PGButton!
    
    let viewModel = InputUsernameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusLabel()
        nextButton.hide()
        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func bindingUsername(sender: UITextField) {
        guard let username = sender.text else { return }
        viewModel.username = username
        setStatusLabel()
        nextButton.slowDisappear()
    }
    
    func setStatusLabel() {
        statusLabel.text = viewModel.statusLabel
        statusLabel.textColor = viewModel.statusColor
    }
    
    @IBAction func duplicateCheckButtonClicked(sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        let alert = PGAlertPresentor()
        
        viewModel.isUnique(username: username, valid: { [weak self] in
            self?.nextButton.slowAppear()
        }, invalid: {
            alert.present(title: "알림", context: "이미 존재하는 아이디입니다.")
        })
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
    
    func isUnique(username: String, valid: @escaping (() -> Void), invalid: @escaping (() -> Void)) {
        let userType = SignUpInformation.shared.userType
        PGNetwork.checkUsernameDuplicate(userType: userType, username: username) { isExists in
            isExists ? invalid() : valid()
        }
    }
}

enum SignUpUsernameStatus: String, SignUpStatus {
    case tooShort = "아직 5자리가 아니에요."
    case valid = "적절한 아이디입니다!"
    case tooLong = "너무 길어요."
    case invalidChar = "영어(필수), 숫자, -, _로만 만들어주세요."
    case noInput = ""
    
    public init() {
        self = .noInput
    }
    
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
