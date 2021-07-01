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
        do {
            try viewModel.requestSignIn()
        } catch SignInError.InvalidIdForTest {
            let alert = AlertPresentor(view: self)
            alert.present(title: "경고", context: "올바르지 않은 ID")
        } catch {
            return
        }
    }
}

class SignInViewModel {
    private var autoLoginChecked: Bool = false
    private var usernameInput: String = ""
    private var passwordInput: String = ""
    private var userType: UserType = .Student
    
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
    
    func requestSignIn() throws {
        // Login API Not Supported
        // call ID for test
        guard let id = Int(usernameInput) else {
            throw SignInError.InvalidIdForTest
        }
        SignedUserInfo.shared.setUserInfo(id: id, type: userType)
        SignedUserInfo.shared.requestSignIn()
    }
}
