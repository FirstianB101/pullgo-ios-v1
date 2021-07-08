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
        
        do {
            let success: ((Data?) -> ()) = { data in
                var teacher: Teacher? = nil
                var student: Student? = nil
                if self.viewModel.userType == .Student {
                    student = try! data?.toObject(type: Student.self)
                    SignedUserInfo.shared.student = student
                    self.presentStudentView()
                } else {
                    teacher = try! data?.toObject(type: Teacher.self)
                    SignedUserInfo.shared.teacher = teacher
                    self.presentStudentView()
                }
                
            }
            let fail: (() -> ()) = {
                alert.present(title: "오류", context: "오류가 발생했습니다.\n잠시 후 다시 시도해주세요.")
                return
            }
            try viewModel.requestSignIn(success: success, fail: fail)
        } catch SignInError.InvalidIdForTest {
            alert.present(title: "경고", context: "올바르지 않은 ID")
        } catch {
            return
        }
    }
    
    func presentTeacherView() {
        let pvc = self.presentingViewController!
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherCalenderViewController") as! TeacherCalenderViewController
        
        self.dismiss(animated: true, completion: {
            pvc.present(vc, animated: true, completion: nil)
        })
    }
    
    func presentStudentView() {
        
    }
}

class SignInViewModel {
    private var autoLoginChecked: Bool = false
    private var usernameInput: String = ""
    private var passwordInput: String = ""
    var userType: UserType = .Student
    
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
    
    func requestSignIn(success: @escaping ((Data?) -> ()), fail: @escaping (() -> ())) throws {
        // Login API Not Supported
        // call ID for test
        guard let id = Int(usernameInput) else {
            throw SignInError.InvalidIdForTest
        }
        SignedUserInfo.shared.setUserInfo(id: id, type: userType)
        SignedUserInfo.shared.requestSignIn(success: success, fail: fail)
    }
}
