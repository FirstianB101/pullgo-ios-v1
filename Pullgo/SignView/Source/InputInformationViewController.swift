//
//  InputInformationViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import UIKit

class InputPhoneViewController: UIViewController, Styler {
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    let viewModel = InputPhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
        setTextFieldUI()
        hide(view: verifyLabel)
        setKeyboardWatcher()
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: completeButton)
        setViewShadow(view: completeButton)
        completeButton.setTitle(viewModel.buttonTitle, for: .normal)
        hide(view: completeButton)
    }
    
    func setTextFieldUI() {
        setTextFieldBorderUnderline(field: phoneField)
        setTextFieldBorderUnderline(field: verifyField)
        hide(view: verifyField)
    }
    
    @IBAction func requestButtonClicked(sender: UIButton) {
        guard let phone = phoneField.text else { return }
        
        if !phone.isPhoneValid {
            showInvalidAlert(message: "전화번호 형식이 올바르지 않습니다.")
            return
        }
        
        blockPhoneFieldInput()
        showHiddenUI()
        viewModel.phone = phone
        viewModel.requestSendVerifyNumber()
    }
    
    func showInvalidAlert(message: String) {
        let alert = AlertPresentor(view: self)
        alert.present(title: "경고", context: message)
    }
    
    func blockPhoneFieldInput() {
        phoneField.isEnabled = false
        verifyButton.isEnabled = false
        phoneField.alpha = 0.3
    }
    
    func showHiddenUI() {
        let animator = AnimationPresentor()
        animator.slowAppear(view: verifyLabel)
        animator.slowAppear(view: verifyField)
        animator.slowAppear(view: completeButton)
    }
    
    @IBAction func completeButtonClicked(sender: UIButton) {
        guard let verifyNumber = verifyField.text else { return }
        
        viewModel.verifyNumber = verifyNumber
        if !viewModel.isVerifyNumberCorrect() {
            showInvalidAlert(message: "인증번호가 올바르지 않습니다.")
            return
        }
        
        decideNextAct()
    }
    
    func decideNextAct() {
        if viewModel.userType == .Student {
            
        } else {
            viewModel.setPhoneNumberOfSignUpInfo()
            SignUpInformation.shared.mergeAccount()
            SignUpInformation.shared.postSignUpInformation()
        }
    }
}

class InputPhoneViewModel {
    var phone: String = ""
    var verifyNumber: String = ""
    var userType: UserType {
        return SignUpInformation.shared.userType
    }
    var buttonTitle: String {
        get {
            if SignUpInformation.shared.userType == .Student {
                return "추가정보 입력"
            } else {
                return "회원가입"
            }
        }
    }
    
    func requestSendVerifyNumber() {
        // request Server to send Message
    }
    
    func isVerifyNumberCorrect() -> Bool {
        // request Server to check correct
        let random = Int.random(in: 0...10)
        
        return random % 2 == 0
    }
    
    func setPhoneNumberOfSignUpInfo() {
        SignUpInformation.shared.account?.phone = self.phone
    }
}

extension String {
    var isPhoneValid: Bool {
        let phoneRegex = "^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$"
        return self.predicate(regex: phoneRegex)
    }
}
