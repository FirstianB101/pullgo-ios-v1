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
}
