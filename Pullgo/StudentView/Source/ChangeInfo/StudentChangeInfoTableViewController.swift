//
//  StudentChangeInfoTableViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/11.
//

import UIKit

class StudentChangeInfoTableViewController: UITableViewController {

    @IBOutlet weak var fullNameField:       UITextField!
    @IBOutlet weak var phoneField:          UITextField!
    @IBOutlet weak var schoolNameField:     UITextField!
    @IBOutlet weak var schoolYearField:     UISegmentedControl!
    @IBOutlet weak var parentPhoneField:    UITextField!
    
    let viewModel = StudentChangeInfoTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewWidth([fullNameField, phoneField, schoolNameField, schoolYearField, parentPhoneField])
        setDefaultInfo()
    }
    
    private func setViewWidth(_ views: [UIView]) {
        let width = self.view.frame.width * 0.4
        
        for view in views {
            view.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        }
    }
    
    private func setDefaultInfo() {
        fullNameField.text = viewModel.getName()
        phoneField.text = viewModel.getPhone()
        schoolNameField.text = viewModel.getSchoolName()
        schoolYearField.selectedSegmentIndex = viewModel.getSchoolYear() - 1
        parentPhoneField.text = viewModel.getParentPhone()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if !checkFieldsInputValid() { return }
        
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "수정", style: .default) { [unowned self] _ in
            self.viewModel.patchUserInfo(newStudent: getNewStudent()) {
                alert.present(title: "알림", context: "회원정보 수정이 완료되었어요.") { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        alert.present(title: "회원정보 수정",
                      context: "입력하신 정보로 회원정보를 수정합니다.",
                      actions: [alert.cancel, okay])
    }
    
    private func checkFieldsInputValid() -> Bool {
        guard let phone = phoneField.text,
              let parentPhone = parentPhoneField.text else { return false }
        
        if !phone.isPhoneValid || !parentPhone.isPhoneValid {
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "전화번호 형식이 올바르지 않습니다.")
            return false
        }
        
        return true
    }
    
    private func getNewStudent() -> Student? {
        let student = Student()
        
        guard let fullName = fullNameField.text,
              let phone = phoneField.text,
              let schoolName = schoolNameField.text,
              let parentPhone = parentPhoneField.text else { return nil }
        let schoolYear = schoolYearField.selectedSegmentIndex + 1
        
        student.id = PGSignedUser.id
        student.account.fullName = fullName
        student.account.phone = phone
        student.schoolName = schoolName
        student.schoolYear = schoolYear
        student.parentPhone = parentPhone
        
        return student
    }
}

class StudentChangeInfoTableViewModel {
    
    public func getName() -> String {
        return PGSignedUser.student.account.fullName
    }
    
    public func getPhone() -> String {
        return PGSignedUser.student.account.phone
    }
    
    public func getSchoolName() -> String {
        return PGSignedUser.student.schoolName
    }
    
    public func getSchoolYear() -> Int {
        return PGSignedUser.student.schoolYear
    }
    
    public func getParentPhone() -> String {
        return PGSignedUser.student.parentPhone
    }
    
    public func patchUserInfo(newStudent: Student?, completion: @escaping (() -> Void)) {
        guard let newStudent = newStudent else {
            let alert = PGAlertPresentor()
            alert.present(title: "오류", context: .unknownError)
            return
        }
        
        newStudent.patch(success: { data in
            guard let student = try? data?.toObject(type: Student.self) else {
                let alert = PGAlertPresentor()
                alert.present(title: "오류", context: .unknownError)
                return
            }
            
            PGSignedUser.student = student
            completion()
        })
    }
}
