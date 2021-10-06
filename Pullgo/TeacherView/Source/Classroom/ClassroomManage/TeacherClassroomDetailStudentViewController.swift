//
//  TeacherClassroomDetailStudentViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/01.
//

import UIKit

class TeacherClassroomDetailStudentViewController: UIViewController {
    let viewModel = TeacherClassroomDetailStudentViewModel()
    
    @IBOutlet weak var callStudentButton: UIButton!
    @IBOutlet weak var messageStudentButton: UIButton!
    @IBOutlet weak var callParentButton: UIButton!
    @IBOutlet weak var messageParentButton: UIButton!
    @IBOutlet weak var kickStudentButton: UIButton!
    
    @IBOutlet weak var schoolInfoLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setButtonUI()
        setStudentInfoLabel()
    }
    
    private func setButtonUI() {
        callStudentButton.setViewCornerRadiusAndShadow(radius: 15)
        messageStudentButton.setViewCornerRadiusAndShadow(radius: 15)
        callParentButton.setViewCornerRadiusAndShadow(radius: 15)
        messageParentButton.setViewCornerRadiusAndShadow(radius: 15)
        kickStudentButton.setViewCornerRadiusAndShadow()
    }
    
    func setStudentInfoLabel() {
        schoolInfoLabel.text = viewModel.getSchoolInfo()
        studentNameLabel.text = viewModel.getStudentName()
    }
    
    @IBAction func callButtonClicked(_ sender: UIButton) {
        var phone: String = ""
        
        if sender == self.callStudentButton {
            phone = viewModel.getStudentPhone()
        } else if sender == self.callParentButton {
            phone = viewModel.getParentPhone()
        }
        
        
    }
    
    @IBAction func messageButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func kickButtonClicked(_ sender: UIButton) {
        let studentName = viewModel.getStudentName()
        
        let alert = PGAlertPresentor(presentor: self)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.viewModel.kickStudent() { _ in
                alert.present(title: "알림", context: "\(studentName)을 내보냈어요.")
            }
        }
        alert.present(title: "학생 내보내기", context: "\(studentName)을 반에서 내보냅니다.",
                      actions: [alert.cancel, action])
    }
}

class TeacherClassroomDetailStudentViewModel {
    var selectedStudent: Student!
    
    public func getStudentPhone() -> String {
        return selectedStudent.account.phone
    }
    
    public func getParentPhone() -> String {
        return selectedStudent.parentPhone
    }
    
    public func getSchoolInfo() -> String {
        return "\(selectedStudent.schoolName!) \(selectedStudent.schoolYear!)학년"
    }
    
    public func getStudentName() -> String {
        return selectedStudent.account.fullName + " 학생"
    }
    
    public func kickStudent(completion: @escaping ((Data?) -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom
            .kick(userType: .student, userId: selectedStudent.id!, completion: completion)
    }
}
