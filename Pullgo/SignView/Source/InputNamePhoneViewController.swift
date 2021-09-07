//
//  InputInformationViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import UIKit

// for TESTING
import UserNotifications

class InputNamePhoneViewController: UIViewController, Styler {
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    let viewModel = InputNamePhoneViewModel()
    var verifyTimer: Timer?
    var timeLeft = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
        setTextFieldUI()
        hide(view: verifyLabel)
        hide(view: timerLabel)
        hide(view: resendButton)
        setKeyboardWatcher()
        
        // for TESTING
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in })
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: completeButton)
        setViewCornerRadius(view: resendButton)
        setViewShadow(view: completeButton)
        setViewShadow(view: resendButton)
        completeButton.setTitle(viewModel.buttonTitle, for: .normal)
        hide(view: completeButton)
    }
    
    func setTextFieldUI() {
        setTextFieldBorderUnderline(field: fullNameField)
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
        startTimer()
    }
    
    func showInvalidAlert(message: String) {
        let alert = AlertPresentor(presentor: self)
        alert.present(title: "경고", context: message)
    }
    
    func blockPhoneFieldInput() {
        phoneField.isEnabled = false
        verifyButton.isEnabled = false
        phoneField.alpha = 0.3
    }
    
    func showHiddenUI() {
        verifyLabel.slowAppear()
        verifyField.slowAppear()
        completeButton.slowAppear()
        timerLabel.slowAppear()
        resendButton.slowAppear()
    }
    
    func startTimer() {
        timeLeft = 180
        verifyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick() {
        var convTime: (minute: String, second: String) = ("3", "00")
        
        convTime = self.secondsToMinute(time: timeLeft)
        self.timerLabel.text = "\(convTime.minute):\(convTime.second)"
        timeLeft -= 1
        
        if timeLeft < 0 {
            self.showInvalidAlert(message: "시간이 만료되었습니다. \n인증번호를 받지 못하셨나요? 버튼을 눌러 새로운 인증번호를 받아주세요.")
            self.verifyTimer?.invalidate()
            self.timerLabel.text = ""
        }
    }
    
    func secondsToMinute(time: Int) -> (String, String) {
        let minute = String(time / 60)
        var second = String(time % 60)
        
        if second.count != 2 {
            second = "0\(second)"
        }
        
        return (minute, second)
    }
    
    @IBAction func resendVerifyNumberClicked(sender: UIButton) {
        self.verifyTimer?.invalidate()
        startTimer()
        viewModel.requestSendVerifyNumber()
    }
    
    @IBAction func completeButtonClicked(sender: UIButton) {
        if !bindingFullName() { return }
        
        guard let verifyNumber = verifyField.text else { return }
        
        viewModel.verifyNumber = verifyNumber
        if !viewModel.isVerifyNumberCorrect() {
            showInvalidAlert(message: "인증번호가 올바르지 않습니다.")
            return
        }
        
        verifyTimer?.invalidate()
        decideNextAct()
    }
    
    func bindingFullName() -> Bool {
        guard let fullName = fullNameField.text else { return false }
        if fullName.isEmpty {
            fullNameField.vibrate()
            return false
        } else {
            viewModel.fullName = fullName
            return true
        }
    }
    
    func decideNextAct() {
        if viewModel.userType == .student {
            let vc = storyboard?.instantiateViewController(withIdentifier: "InputDetailViewController") as! InputDetailViewController
            self.navigationItem.backButtonTitle = "전화번호 입력"
            navigationController?.pushViewController(vc, animated: true)
        } else {
            viewModel.setPhoneNumberOfSignUpInfo()
            SignUpInformation.shared.mergeAccount()
            sendTeacherPostRequest()
        }
    }
    
    func sendTeacherPostRequest() {
        let action = UIAlertAction(title: "확인", style: .default) { handler in
            self.dismiss(animated: true, completion: nil)
        }
        let alert = AlertPresentor(presentor: self)
        let success: ResponseClosure = { data in
            alert.present(title: "알림", context: "회원가입이 완료되었습니다.\n입력하신 정보로 로그인해주세요.", actions: [action])
        }
        let fail = {
            alert.present(title: "오류", context: .NetworkError, actions: [action])
        }
        
        viewModel.postRequest(success: success, fail: fail)
    }
}

class InputNamePhoneViewModel {
    private var _fullName: String = ""
    var fullName: String {
        get { _fullName }
        set {
            _fullName = newValue
            SignUpInformation.shared.account?.fullName = newValue
        }
    }
    var phone: String = ""
    var verifyNumber: String = ""
    var userType: UserType {
        return SignUpInformation.shared.userType
    }
    var buttonTitle: String {
        get {
            if SignUpInformation.shared.userType == .student {
                return "추가정보 입력"
            } else {
                return "회원가입"
            }
        }
    }
    
    // MARK: for TESTING
    var testNumber: String = ""
    
    func requestSendVerifyNumber() {
        // request Server to send Message
        testNumber = "1111"//String(Int.random(in: 1000...9999))
        
        let content = UNMutableNotificationContent()
        content.title = "풀고"
        content.subtitle = "인증번호 알림"
        content.body = "인증번호: \(testNumber)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "pullgo", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func isVerifyNumberCorrect() -> Bool {
        // request Server to check correct
        return testNumber == verifyNumber
    }
    
    func setPhoneNumberOfSignUpInfo() {
        SignUpInformation.shared.account?.phone = self.phone
    }
    
    func postRequest(success: @escaping ResponseClosure, fail: @escaping FailClosure) {
        SignUpInformation.shared.postSignUpInformation(success: success, fail: fail)
    }
}

extension String {
    var isPhoneValid: Bool {
        let phoneRegex = "^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$"
        return self.predicate(regex: phoneRegex)
    }
}

