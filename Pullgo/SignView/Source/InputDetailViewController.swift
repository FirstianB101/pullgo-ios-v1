//
//  InputDetailViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/04.
//

import UIKit

class InputDetailViewController: UIViewController {
    
    @IBOutlet weak var parentPhoneField: PGTextField!
    @IBOutlet weak var schoolNameField: PGTextField!
    @IBOutlet weak var schoolYearSegment: UISegmentedControl!
    @IBOutlet weak var signUpButton: PGButton!
    
    let viewModel = InputDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func signUpButtonClicked(sender: UIButton) {
        setViewModelData()
        
        let alert = PGAlertPresentor(presentor: self)
        if !viewModel.isParentPhoneValid() {
            alert.present(title: "경고", context: "전화번호 형식이 올바르지 않습니다.")
            return
        } else if !viewModel.isSchoolNameValid() {
            alert.present(title: "경고", context: "\"**중/고등학교\"까지 입력해주세요.")
            return
        }
        
        let context = """
            학교 정보
            \(viewModel.schoolName) \(viewModel.schoolYear)학년
            부모님 전화번호
            \(viewModel.parentPhone)
            
            이 정보로 회원가입을 진행할까요?
            """
        
        let cancel = alert.cancel
        let okay = UIAlertAction(title: "회원가입", style: .default, handler: { _ in
            self.sendTeacherPostRequest()
        })
        
        alert.present(title: "알림", context: context, actions: [cancel, okay])
    }
    
    func setViewModelData() {
        guard let parentPhone = parentPhoneField.text else { return }
        guard let schoolName = schoolNameField.text else { return }
        
        viewModel.parentPhone = parentPhone
        viewModel.schoolName = schoolName
        viewModel.schoolYear = schoolYearSegment.selectedSegmentIndex + 1
    }
    
    func sendTeacherPostRequest() {
        
        viewModel.postRequest(success: { data in
            let alert = PGAlertPresentor(presentor: self)
            let action = UIAlertAction(title: "확인", style: .default) { handler in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.present(title: "알림", context: "회원가입이 완료되었습니다.\n입력하신 정보로 로그인해주세요.", actions: [action])
        })
    }
}

class InputDetailViewModel {
    var _parentPhone: String = ""
    var parentPhone: String {
        get { _parentPhone }
        set {
            _parentPhone = newValue
            SignUpInformation.shared.student?.parentPhone = newValue
        }
    }
    var _schoolName: String = ""
    var schoolName: String {
        get { _schoolName }
        set {
            _schoolName = newValue
            SignUpInformation.shared.student?.schoolName = newValue
        }
    }
    var _schoolYear: Int = 1
    var schoolYear: Int {
        get { _schoolYear }
        set {
            _schoolYear = newValue
            SignUpInformation.shared.student?.schoolYear = newValue
        }
    }
    
    func isParentPhoneValid() -> Bool {
        return parentPhone.isPhoneValid
    }
    
    func isSchoolNameValid() -> Bool {
        return schoolName.contains("학교")
    }
    
    func postRequest(success: @escaping ((Data?) -> Void)) {
        SignUpInformation.shared.student?.post(success: success)
    }
}
