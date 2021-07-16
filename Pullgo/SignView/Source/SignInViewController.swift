//
//  SignInViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/27.
//

import UIKit

class SignInViewController: UIViewController, Styler {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userTypeSegment: UISegmentedControl!
    
    let viewModel: SignInViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldUI()
        setButtonUI()
        setKeyboardWatcher()
    }
    
    private func setTextFieldUI() {
        setTextFieldCornerRadius()
        setTextFieldPadding()
        setTextFieldShadow()
    }
    
    private func setTextFieldCornerRadius() {
        setViewCornerRadius(view: usernameField)
        setViewCornerRadius(view: passwordField)
    }
    
    private func setTextFieldPadding() {
        setTextFieldPadding(field: usernameField)
        setTextFieldPadding(field: passwordField)
    }
    
    private func setTextFieldShadow() {
        setViewShadow(view: usernameField)
        setViewShadow(view: passwordField)
    }
    
    private func setButtonUI() {
        setDefaultButtonStyle(button: signInButton)
    }
    
    @IBAction func autoSignInClicked(sender: UIButton) {
        viewModel.toggleAutoLoginStatus()
        toggleAutoSignInImage(sender: sender)
    }
    
    func toggleAutoSignInImage(sender: UIButton) {
        let uncheckedImage: UIImage = UIImage(systemName: "square")!
        let checkedImage: UIImage = UIImage(systemName: "checkmark.square.fill")!
        
        if viewModel.isAutoLoginChecked() {
            sender.setImage(checkedImage, for: .normal)
        } else {
            sender.setImage(uncheckedImage, for: .normal)
        }
    }
    
    @IBAction func signInClicked(sender: UIButton) {
        let username: String = usernameField.text!
        let password: String = passwordField.text!
        let userType: UserType = .ToUserType(index: userTypeSegment.selectedSegmentIndex)!
        let animator: AnimationPresentor = AnimationPresentor()
        
        if username.isEmpty {
            animator.vibrate(view: usernameField)
        } else if password.isEmpty {
            animator.vibrate(view: passwordField)
        } else {
            viewModel.setInputs(username: username, password: password, userType: userType)
            requestSignIn()
        }
    }
    
    func requestSignIn() {
        let alert = AlertPresentor(view: self)
        
        let success: ((Data?) -> ()) = { data in
            var teacher: Teacher? = nil
            var student: Student? = nil
            if self.viewModel.userType == .student {
                student = try! data?.toObject(type: Student.self)
                SignedUserInfo.shared.student = student
                self.presentStudentView()
            } else {
                teacher = try! data?.toObject(type: Teacher.self)
                SignedUserInfo.shared.teacher = teacher
                self.presentTeacherView()
            }
        }
        let fail: (() -> ()) = {
            alert.presentNetworkError()
            return
        }
        
        viewModel.requestSignIn(success: success, fail: fail)
    }
    
    func presentTeacherView() {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherCalendarViewController") as! TeacherCalendarViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
    
    func presentStudentView() {
        
    }
}

class SignInViewModel {
    private var autoLoginChecked: Bool = false
    private var usernameInput: String = ""
    private var passwordInput: String = ""
    var userType: UserType = .student
    
    func isAutoLoginChecked() -> Bool {
        return autoLoginChecked
    }
    
    func toggleAutoLoginStatus() {
        autoLoginChecked = !autoLoginChecked
    }
    
    func setInputs(username: String, password: String, userType: UserType) {
        self.usernameInput = username
        self.passwordInput = password
        self.userType = userType
    }
    
    func requestSignIn(success: @escaping ((Data?) -> ()), fail: @escaping (() -> ())) {
        // Login API Not Supported
        // call ID for test
        guard let id = Int(usernameInput) else { return }
        SignedUserInfo.shared.setUserInfo(id: id, type: userType)
        SignedUserInfo.shared.requestSignIn(success: success, fail: fail)
    }
}
