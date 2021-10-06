//
//  TeacherInputNewInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa

class TeacherInputNewInfoViewController: UIViewController {
    
    @IBOutlet weak var newFullNameField: PGTextField!
    @IBOutlet weak var newPasswordField: PGTextField!
    @IBOutlet weak var checkPasswordField: PGTextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var checkPasswordLabel: UILabel!
    @IBOutlet weak var editButton: PGButton!
    
    let viewModel = TeacherInputNewInfoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        bindInputToRelay()
        bindViewModel()
    }
    
    private func bindInputToRelay() {
        newFullNameField.rx.text.orEmpty
            .bind(to: viewModel.newFullnameRelay)
            .disposed(by: disposeBag)
        
        newPasswordField.rx.text.orEmpty
            .bind(to: viewModel.newPasswordRelay)
            .disposed(by: disposeBag)
        
        
        checkPasswordField.rx.text.orEmpty
            .bind(to: viewModel.checkPasswordRelay)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.newFullnameRelay
            .map { !$0.isEmpty }
            .bind(to: viewModel.newFullnameStatus)
            .disposed(by: disposeBag)
        
        viewModel.newPasswordRelay
            .map(viewModel.getPasswordStatus(_:))
            .bind(to: viewModel.newPasswordStatus)
            .disposed(by: disposeBag)
        
        viewModel.checkPasswordRelay
            .map(viewModel.isPasswordEqual(_:))
            .bind(to: viewModel.checkPasswordStatus)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        bindEditButton()
        
        viewModel.newPasswordStatus
            .subscribe(onNext: { [weak self] status in
                self?.setTextAndColor(self?.passwordValidLabel, by: status)
            })
            .disposed(by: disposeBag)
        
        viewModel.checkPasswordStatus
            .subscribe(onNext: { [weak self] status in
                self?.setTextAndColor(self?.checkPasswordLabel, by: status)
            })
            .disposed(by: disposeBag)
    }
    
    private func setTextAndColor(_ label: UILabel?, by status: SignUpStatus) {
        label?.text = status.getMessage()
        label?.textColor = status.getColor()
    }
    
    private func bindEditButton() {
        viewModel.isValid()
            .bind(to: editButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid()
            .map { $0 ? 1 : 0.3 }
            .bind(to: editButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    @IBAction func applyInfo(_ sender: PGButton) {
        viewModel.patchInfo(complete: { data in
            let alert = PGAlertPresentor(presentor: self)
            
            guard let convertedData = try? data?.toObject(type: Teacher.self) else {
                alert.present(title: "오류", context: .unknownError)
                return
            }
            
            PGSignedUser.teacher = convertedData
            
            alert.present(title: "알림", context: "회원정보 수정이 완료되었습니다.") { _ in
                TeacherViewSwitcher.switchView(self, presenting: .calendarView)
            }
        })
    }
}

class TeacherInputNewInfoViewModel {
    let newFullnameRelay = BehaviorRelay<String>(value: "")
    let newPasswordRelay = BehaviorRelay<String>(value: "")
    let checkPasswordRelay = BehaviorRelay<String>(value: "")
    
    let newFullnameStatus = BehaviorSubject<Bool>(value: false)
    let newPasswordStatus = BehaviorSubject<SignUpPasswordStatus>(value: .noInput)
    let checkPasswordStatus = BehaviorSubject<SignUpPasswordCheck>(value: .noInput)
    
    public func isValid() -> Observable<Bool> {
        return Observable.combineLatest(newFullnameRelay, newPasswordRelay, checkPasswordRelay)
            .map { [weak self] fullname, password, checkPassword in
                let isFullnameValid = !fullname.isEmpty
                let passwordStatus = self?.getPasswordStatus(password)
                let checkPasswordStatus = self?.isPasswordEqual(checkPassword)
                
                // fullname이 유효할 때
                if isFullnameValid == true {
                    // 비밀번호가 입력되어 있지 않으면
                    if passwordStatus == .noInput && checkPasswordStatus == .noInput {
                        return true
                    }
                    // 비밀번호가 유효하면
                    else if passwordStatus == .valid && checkPasswordStatus == .correct {
                        return true
                    }
                }
                // username 유효하지 않을 때
                else {
                    // 비밀번호가 유효하면
                    if passwordStatus == .valid && checkPasswordStatus == .correct {
                        return true
                    }
                }
                
                return false
            }
    }
    
    public func getPasswordStatus(_ value: String) -> SignUpPasswordStatus {
        return .getStatus(of: value)
    }
    
    public func isPasswordEqual(_ value: String) -> SignUpPasswordCheck {
        return .getStatus(origin: newPasswordRelay.value, check: value)
    }
    
    public func patchInfo(complete: @escaping ((Data?) -> Void)) {
        let teacher = Teacher()
        teacher.id = PGSignedUser.id!
        teacher.account = Account()
        
        if !newFullnameRelay.value.isEmpty {
            teacher.account.fullName = newFullnameRelay.value
        }
        if self.getPasswordStatus(newPasswordRelay.value) == .valid &&
            self.isPasswordEqual(checkPasswordRelay.value) == .correct {
            teacher.account.password = newPasswordRelay.value
        }
        
        teacher.patch(success: complete)
    }
}
