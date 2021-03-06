//
//  InputPasswordViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import UIKit

class InputPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: PGTextField!
    @IBOutlet weak var checkTextField: PGTextField!
    @IBOutlet weak var passwordStatusLabel: UILabel!
    @IBOutlet weak var correctCheckLabel: UILabel!
    @IBOutlet weak var nextButton: PGButton!
    
    let viewModel = InputPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        self.setKeyboardDismissWatcher()
    }
    
    func setUI() {
        setPasswordStatusUI()
        setCheckStatusUI()
    }
    
    @IBAction func bindingPasswordInput(sender: UITextField) {
        guard let password = sender.text else { return }
        viewModel.password = password
        setPasswordStatusUI()
    }
    
    func setPasswordStatusUI() {
        passwordStatusLabel.text = viewModel.statusMessage
        passwordStatusLabel.textColor = viewModel.statusColor
    }
    
    @IBAction func bindingPasswordCheck(sender: UITextField) {
        guard let check = sender.text else { return }
        viewModel.check = check
        setCheckStatusUI()
    }
    
    func setCheckStatusUI() {
        correctCheckLabel.text = viewModel.checkMessage
        correctCheckLabel.textColor = viewModel.checkColor
    }
    
    @IBAction func nextButtonClicked(sender: UIButton) {
        if !checkAllFieldValid(fields: [passwordTextField, checkTextField]) { return }
            
        if viewModel.status != .valid {
            passwordStatusLabel.vibrate()
        } else if viewModel.checkStatus != .correct {
            correctCheckLabel.vibrate()
        } else {
            SignUpInformation.shared.account?.password = viewModel.password
            presentInputPhoneView()
        }
    }
    
    func presentInputPhoneView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputNamePhoneViewController") as! InputNamePhoneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class InputPasswordViewModel {
    private var _password: String = ""
    var password: String {
        get { _password }
        set {
            _password = newValue
            self.status = .getStatus(of: newValue)
        }
    }
    
    private var _check: String = ""
    var check: String {
        get { _check }
        set {
            _check = newValue
            self.checkStatus = .getStatus(origin: _password, check: newValue)
        }
    }
    
    var status: SignUpPasswordStatus = .noInput
    var checkStatus: SignUpPasswordCheck = .noInput
    
    var statusMessage: String {
        return status.getMessage()
    }
    
    var statusColor: UIColor {
        return status.getColor()
    }
    
    var checkMessage: String {
        return checkStatus.getMessage()
    }
    
    var checkColor: UIColor {
        return checkStatus.getColor()
    }
}

enum SignUpPasswordStatus: String, SignUpStatus {
    case tooShort = "너무 짧아요."
    case valid = "적절한 비밀번호에요!"
    case tooLong = "너무 길어요."
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
    
    static func getStatus(of password: String) -> SignUpPasswordStatus {
        if password.isEmpty { return .noInput }
        else if password.count < 8 { return .tooShort }
        else if password.count > 16 { return .tooLong }
        else { return .valid }
    }
}

enum SignUpPasswordCheck: String, SignUpStatus {
    
    case correct = "비밀번호가 일치해요 :)"
    case incorrect = "비밀번호가 일치하지 않아요."
    case noInput = ""
    
    public init() {
        self = .noInput
    }
    
    func getColor() -> UIColor {
        if self == .correct { return .systemGreen }
        else { return .systemPink }
    }
    
    func getMessage() -> String {
        return self.rawValue
    }
    
    static func getStatus(origin: String, check: String) -> SignUpPasswordCheck {
        if check.isEmpty { return .noInput }
        else if origin == check { return .correct }
        else { return .incorrect }
    }
    
    static func getStatus(of input: String) -> SignUpPasswordCheck {
        return .noInput
    }
}
