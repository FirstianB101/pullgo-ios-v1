//
//  TeacherChangePasswordViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/16.
//

import UIKit
import RxSwift
import RxCocoa

class TeacherChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordField: PGTextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var checkPasswordField: PGTextField!
    @IBOutlet weak var checkPasswordValidLabel: UILabel!
    
    let viewModel = TeacherChangePasswordViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: disposeBag)
        
        checkPasswordField.rx.text.orEmpty
            .bind(to: viewModel.checkPasswordInput)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.passwordInput
            .map({ SignUpPasswordStatus.getStatus(of: $0) })
            .bind { [weak self] status in
                guard let self = self else { return }
                self.bindLabelStatus(in: self.passwordValidLabel, status: status)
            }
            .disposed(by: disposeBag)
        
        viewModel.checkPasswordStatus
            .bind { [weak self] status in
                guard let self = self else { return }
                self.bindLabelStatus(in: self.checkPasswordValidLabel, status: status)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindLabelStatus(in label: UILabel, status: SignUpStatus) {
        label.text = status.getMessage()
        label.textColor = status.getColor()
    }
    
    @IBAction func changePasswordClicked(_ sender: PGButton) {
        let alert = PGAlertPresentor()
        
        guard viewModel.isPasswordCheckValid() else {
            alert.present(title: "알림", context: "비밀번호를 확인해주세요.")
            return
        }
        
        let okay = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.viewModel.patchPassword {
                alert.present(title: "알림", context: "비밀번호 변경이 완료되었습니다.") { _ in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        alert.present(title: "알림", context: "비밀번호를 변경합니다.", actions: [alert.cancel, okay])
    }
}

class TeacherChangePasswordViewModel {
    
    let passwordInput = BehaviorRelay<String>(value: "")
    let checkPasswordInput = BehaviorRelay<String>(value: "")
    
    var checkPasswordStatus: Observable<SignUpPasswordCheck> {
        return Observable<SignUpPasswordCheck>.combineLatest(passwordInput, checkPasswordInput) { origin, check in
            SignUpPasswordCheck.getStatus(origin: origin, check: check)
        }
    }
    
    public func isPasswordCheckValid() -> Bool {
        return passwordInput.value == checkPasswordInput.value
    }
    
    public func patchPassword(complete: @escaping (() -> Void)) {
        let teacher = Teacher()
        teacher.id = PGSignedUser.id
        teacher.account = PGSignedUser.teacher.account
        
        teacher.account.password = passwordInput.value
        teacher.patch(success: { data in
            guard let received = try? data?.toObject(type: Teacher.self) else {
                print("Teacher::patch failed.")
                return
            }
            
            PGSignedUser.teacher = received
            complete()
        })
    }
}
