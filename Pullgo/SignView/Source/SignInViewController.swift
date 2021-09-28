//
//  SignInViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/27.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: PGButton!
    @IBOutlet weak var userTypeSegment: UISegmentedControl!
    
    let viewModel = SignInViewModel()
    
    let autoLoginCheckedImage = UIImage(systemName: "square")!
    let autoLoginUncheckedImage = UIImage(systemName: "checkmark.square.fill")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldUI()
        self.setKeyboardDismissWatcher()
    }
    
    private func setTextFieldUI() {
        usernameField.setViewCornerRadiusAndShadow()
        passwordField.setViewCornerRadiusAndShadow()
        usernameField.setTextFieldPadding()
        passwordField.setTextFieldPadding()
    }
    
    private func presentTeacherView() {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherCalendarViewController") as! TeacherCalendarViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
    
    private func presentStudentView() {
        
    }
}

// MARK: IBActions
extension SignInViewController {
    @IBAction func signInButtonClicked(_ sender: PGButton) {
        let userType = UserType.toUserType(index: self.userTypeSegment.selectedSegmentIndex)!
        
        if !self.checkAllFieldValid(fields: [usernameField, passwordField]) { return }
        
        viewModel.setInputs(username: usernameField.text!, password: passwordField.text!, userType: userType)
        viewModel.signInProcess(fail: self.signInFail, completion: self.signInSuccess)
    }
    
    private func signInFail(error: PGNetworkError) {
        var message: Message = .networkError
        
        if error.responseCode == 401 {
            message = .signInFail
        }
        
        let presentor = PGAlertPresentor(presentor: self)
        presentor.present(title: "알림", context: message)
    }
    
    private func signInSuccess(data: Data?) {
        
        do {
            guard let userInfo = try data?.toObject(type: _PGSignedUser.self) else { return }
            print(userInfo.student)
            print(userInfo.teacher)
            print(userInfo.token)
            
            viewModel.setPGSignedUser(userInfo: userInfo)
            viewModel.autoLoginProcess()
            
            if viewModel.userType == .student {
                self.presentStudentView()
            } else if viewModel.userType == .teacher {
                self.presentTeacherView()
            }
            
        } catch {
            let presentor = PGAlertPresentor(presentor: self)
            presentor.present(title: "오류", context: .unknownError)
        }
    }
    
    @IBAction func autoLoginButtonClicked(_ sender: UIButton) {
        viewModel.toggleAutoLoginStatus()
        let image = viewModel.isAutoLoginChecked() ?
            self.autoLoginCheckedImage : self.autoLoginUncheckedImage
        sender.setImage(image, for: .normal)
    }
}

class SignInViewModel {
    private var autoLoginChecked: Bool = false
    private var usernameInput: String = ""
    private var passwordInput: String = ""
    var userType: UserType = .student
    
    public func isAutoLoginChecked() -> Bool {
        return autoLoginChecked
    }
    
    public func toggleAutoLoginStatus() {
        autoLoginChecked = !autoLoginChecked
    }
    
    public func setInputs(username: String, password: String, userType: UserType) {
        self.usernameInput = username
        self.passwordInput = password
        self.userType = userType
    }
    
    public func signInProcess(fail: @escaping ((PGNetworkError) -> Void), completion: @escaping ((Data?) -> Void)) {
        PGSignedUser.signIn(username: self.usernameInput,
                            password: self.passwordInput,
                            success: completion,
                            fail: fail)
    }
    
    public func setPGSignedUser(userInfo: _PGSignedUser) {
        PGSignedUser.token = userInfo.token
        if self.userType == .student {
            PGSignedUser.student = userInfo.student
            PGSignedUser.userType = .student
        } else if self.userType == .teacher {
            PGSignedUser.teacher = userInfo.teacher
            PGSignedUser.userType = .teacher
        }
    }
    
    public func autoLoginProcess() {
        if self.autoLoginChecked == false { return }
        
        // 키체인에 토큰 저장
    }
}
