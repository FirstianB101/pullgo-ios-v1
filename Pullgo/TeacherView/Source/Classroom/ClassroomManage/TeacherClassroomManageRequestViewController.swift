//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageRequestViewController: UIViewController, TeacherClassroomManageTopBar {
    
    @IBOutlet weak var requestCollectionView: UICollectionView!
    @IBOutlet weak var userTypeSegment: UISegmentedControl!
    let viewModel = TeacherClassroomManageRequestViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setSegmentUI()
        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        requestCollectionView.setCollectionViewBackgroundColor()
        viewModel.updateRequest() {
            self.requestCollectionView.reloadData()
        }
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "요청 관리"
    }
    
    func setSegmentUI() {
        
    }
    
    @IBAction func userTypeSelected(_ sender: UISegmentedControl) {
        viewModel.userType = UserType.toUserType(index: sender.selectedSegmentIndex)!
        self.requestCollectionView.reloadData()
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.userType == .student ? viewModel.appliedStudents.count : viewModel.appliedTeachers.count
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherClassroomManageRequestCell", for: indexPath) as! TeacherClassroomManageRequestCell
        
        if viewModel.userType == .student {
            cell.fullName.text = viewModel.getStudentName(at: indexPath.item)
            cell.studentSchoolInfo.text = viewModel.getSchoolInfo(at: indexPath.item)
        } else {
            cell.fullName.text = viewModel.getTeacherName(at: indexPath.item)
            cell.studentSchoolInfo.text = ""
        }
        
        cell.setCellUI()
        cell.applyRequestButton.setViewCornerRadiusAndShadow(radius: 7)
        
        return cell
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 20, height: 128)
    }
}

class TeacherClassroomManageRequestCell: UICollectionViewCell {
    @IBOutlet weak var studentSchoolInfo: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var applyRequestButton: UIButton!
    
    @IBAction func deleteRequest(_ sender: UIButton) {
        
    }
    
    @IBAction func applyRequest(_ sender: UIButton) {
        
    }
}

class TeacherClassroomManageRequestViewModel {
    var appliedStudents = [Student]()
    var appliedTeachers = [Teacher]()
    var userType: UserType = .student
    
    var page: Int = 0
    
    func updateRequest(complete: @escaping (() -> Void)) {
        updateRequestTeachers(complete: complete)
        updateRequestStudents(complete: complete)
    }
    
    func updateRequestTeachers(complete: @escaping (() -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom.getAppliedTeachers(page: self.page) { teachers in
            self.appliedTeachers = teachers
            complete()
        }
    }
    
    func updateRequestStudents(complete:  @escaping (() -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom.getAppliedStudents(page: self.page) { students in
            self.appliedStudents = students
            complete()
        }
    }
    
    func getStudentName(at index: Int) -> String {
        let student = self.appliedStudents[index]
        return student.account.fullName + " 학생"
    }
    
    func getSchoolInfo(at index: Int) -> String {
        let student = self.appliedStudents[index]
        return student.schoolName + " " + "\(String(student.schoolYear))학년"
    }
    
    func getTeacherName(at index: Int) -> String {
        let teacher = self.appliedTeachers[index]
        return teacher.account.fullName + " 선생님"
    }
}
