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
    @IBOutlet weak var signInButton: UIButton!
    
    let viewModel: SignInViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFieldDesign()
        setButtonCornerRadiusAndShadow()
    }
    
    func setFieldDesign() {
        setFieldCornerRadius()
        setFieldShadowAndPadding(field: usernameField)
        setFieldShadowAndPadding(field: passwordField)
    }
    
    func setButtonCornerRadiusAndShadow() {
        let cornerRadius = signInButton.frame.height / 2
        signInButton.layer.cornerRadius = cornerRadius
        setViewShadow(view: signInButton)
    }

    func setFieldCornerRadius() {
        let cornerRadius: CGFloat = usernameField.frame.height / 2
        usernameField.layer.cornerRadius = cornerRadius
        passwordField.layer.cornerRadius = cornerRadius
    }
    
    func setFieldShadowAndPadding(field: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        field.leftView = paddingView
        field.leftViewMode = .always
        setViewShadow(view: field)
    }
    
    func setViewShadow(view: UIView) {
        let shadowOffset = CGSize(width: 1, height: 1)
        
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
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
        
    }
}

class SignInViewModel {
    private var autoLoginChecked: Bool = false
    private var usernameInput: String = ""
    private var passwordInput: String = ""
    
    func isAutoLoginChecked() -> Bool {
        return autoLoginChecked
    }
    
    func toggleAutoLoginStatus() {
        autoLoginChecked = !autoLoginChecked
    }
    
    func setUsernameAndPassword(username: String, password: String) {
        usernameInput = username
        passwordInput = password
    }
}
