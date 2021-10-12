//
//  StudentChangePasswordViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/12.
//

import UIKit
import RxSwift
import RxCocoa

class StudentChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordField: PGTextField!
    @IBOutlet weak var passwordStateLabel: UILabel!
    @IBOutlet weak var checkPasswordField: PGTextField!
    @IBOutlet weak var checkPasswordStateLabel: UILabel!
    
    let viewModel = StudentChangePasswordViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindInput()
        bindUIbyStatus()
    }
    
    private func bindInput() {
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.passwordStatus)
            .disposed(by: disposeBag)
        
        checkPasswordField.rx.text.orEmpty
            .bind(to: viewModel.checkPasswordStatus)
            .disposed(by: disposeBag)
    }
    
    private func bindUIbyStatus() {
        viewModel.passwordStatus
            .map({ SignUpPasswordStatus.getStatus(of: $0) })
            .map({ ($0.getMessage(), $0.getColor()) })
            .bind(onNext: { [weak self] message, color in
                self?.passwordStateLabel.text = message
                self?.passwordStateLabel.textColor = color
            })
            .disposed(by: disposeBag)
        
        viewModel.getCheckPasswordStatus
            .map({ ($0.getMessage(), $0.getColor() )})
            .bind(onNext: { [weak self] message, color in
                self?.checkPasswordStateLabel.text = message
                self?.checkPasswordStateLabel.textColor = color
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func changePassword(_ sender: PGButton) {
        let alert = PGAlertPresentor()
        
        if !viewModel.isPasswordSame(origin: passwordField.text, check: checkPasswordField.text) {
            alert.present(title: "알림", context: "비밀번호를 확인해주세요.")
            return
        }
        
        let okay = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.viewModel.changePassword {
                alert.present(title: "수정 완료", context: "비밀번호 수정이 완료되었어요.") { _ in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        alert.present(title: "알림", context: "입력하신 정보로 비밀번호를 수정할까요?", actions: [alert.cancel, okay])
    }
}

class StudentChangePasswordViewModel {
    
    let passwordStatus = BehaviorRelay<String>(value: "")
    let checkPasswordStatus = BehaviorRelay<String>(value: "")
    
    public var getCheckPasswordStatus: Observable<SignUpPasswordCheck> {
        return Observable.combineLatest(passwordStatus, checkPasswordStatus) { origin, check in
            return SignUpPasswordCheck.getStatus(origin: origin, check: check)
        }
    }
    
    public func isPasswordSame(origin: String?, check: String?) -> Bool {
        guard let origin = origin, let check = check else { return false }
        if origin.isEmpty { return false }
        else if check != origin { return false }
        
        return true
    }
    
    public func changePassword(completion: @escaping (() -> Void)) {
        let newStudent = Student()
        newStudent.id = PGSignedUser.id
        newStudent.account.password = self.passwordStatus.value
        
        newStudent.patch(success: { data in
            guard let received = try? data?.toObject(type: Student.self) else {
                let alert = PGAlertPresentor()
                alert.present(title: "오류", context: .unknownError)
                return
            }
            
            PGSignedUser.student = received
            completion()
        })
    }
}
