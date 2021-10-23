//
//  TeacherChangeInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa

class TeacherChangeInfoViewController: UIViewController {
    
    @IBOutlet weak var passwordField: PGTextField!
    @IBOutlet weak var confirmPasswordButton: PGButton!
    @IBOutlet weak var editInfoButton: PGButton!
    
    let viewModel = TeacherChangeInfoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindInput()
        self.setKeyboardDismissWatcher()
    }
    
    private func setUI() {
        editInfoButton.gettingDark()
        passwordField.isEnabled = true
    }
    
    private func bindInput() {
        passwordField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] in self?.viewModel.inputPassword($0) })
            .disposed(by: disposeBag)
    }
    
    @IBAction func confirmPasswordButtonClicked(_ sender: PGButton) {
        viewModel.confirmPassword(success: { [weak self] in
            self?.editInfoButton.gettingBright()
            self?.passwordField.isEnabled = false
        }, fail: {
            let alert = PGAlertPresentor(presentor: self)
            alert.present(title: "알림", context: "비밀번호가 다릅니다. 다시 입력해주세요.")
        })
    }
    
    @IBAction func presentInputNewInfo(_ sender: PGButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherInputNewInfoNavigationController") else { return }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }
}

class TeacherChangeInfoViewModel {
    private var password: String = ""
    
    public func inputPassword(_ password: String) {
        self.password = password
    }
    
    public func confirmPassword(success: @escaping (() -> Void), fail: @escaping (() -> Void)) {
        // 비밀번호 확인하기
        success()
    }
}
