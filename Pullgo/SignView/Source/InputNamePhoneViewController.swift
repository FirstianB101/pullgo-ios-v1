//
//  InputInformationViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/02.
//

import UIKit

// for TESTING
import UserNotifications

class InputNamePhoneViewController: UIViewController {
    
    @IBOutlet weak var fullNameField: PGTextField!
    @IBOutlet weak var phoneField: PGTextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyField: PGTextField!
    @IBOutlet weak var completeButton: PGButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    let viewModel = InputNamePhoneViewModel()
    var verifyTimer: Timer?
    var timeLeft = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.setTitle(viewModel.buttonTitle, for: .normal)
        hideUI()
        self.setKeyboardDismissWatcher()
        
        // for TESTING
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in })
    }
    
    func hideUI() {
        verifyLabel.hide()
        verifyField.hide()
        timerLabel.hide()
        resendButton.hide()
        completeButton.hide()
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
        let alert = PGAlertPresentor(presentor: self)
        alert.present(title: "경고", context: message)
    }
    
    private func blockPhoneFieldInput() {
        phoneField.isEnabled = false
        verifyButton.isEnabled = false
        phoneField.alpha = 0.3
    }
    
    private func unblockPhoneFieldInput() {
        phoneField.isEnabled = true
        verifyButton.isEnabled = true
        phoneField.slowAppear()
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
            unblockPhoneFieldInput()
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
        if !checkAllFieldValid(fields: [verifyField, fullNameField, phoneField]) { return }
        
        viewModel.fullName = fullNameField.text!
        viewModel.verifyNumber = verifyField.text!
        
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
        guard let teacher = SignUpInformation.shared.teacher else { return }
        
        teacher.post(success: { _ in
            let presentor = PGAlertPresentor(presentor: self)
            let action = UIAlertAction(title: "로그인 화면으로", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            presentor.present(title: "알림", context: "풀고의 회원이 되신 것을 환영합니다!", actions: [action])
        })
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
    
}

extension String {
    var isPhoneValid: Bool {
        let phoneRegex = "^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$"
        return self.predicate(regex: phoneRegex)
    }
}

