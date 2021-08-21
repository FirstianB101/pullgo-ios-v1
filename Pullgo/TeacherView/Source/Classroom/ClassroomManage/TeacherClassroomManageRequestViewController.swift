//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageRequestViewController: UIViewController, TeacherClassroomManageTopBar, NetworkAlertDelegate {
    
    @IBOutlet weak var requestCollectionView: UICollectionView!
    @IBOutlet weak var userTypeSegment: UISegmentedControl!
    let viewModel = TeacherClassroomManageRequestViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setSegmentUI()
        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.networkAlertDelegate = self
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
        viewModel.userType = UserType.ToUserType(index: sender.selectedSegmentIndex)!
        self.requestCollectionView.reloadData()
    }
    
    func networkFailAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.presentNetworkError()
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDataSource, Styler {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.userType == .student ? viewModel.requestStudents.count : viewModel.requestTeachers.count
        
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
        
        setCellUI(cell: cell)
        setViewCornerRadius(view: cell.applyRequestButton, radius: 7)
        
        return cell
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 40, height: 128)
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
    var requestStudents = [Student]()
    var requestTeachers = [Teacher]()
    var networkAlertDelegate: NetworkAlertDelegate?
    var userType: UserType = .student
    
    func updateRequest(complete: EmptyClosure? = nil) {
        updateRequestTeachers(complete: complete)
        updateRequestStudents(complete: complete)
    }
    
    func updateRequestTeachers(complete: EmptyClosure? = nil) {
        TeacherClassroomManageViewModel.selectedClassroom.getRequestTeachers() {
            self.requestTeachers = TeacherClassroomManageViewModel.selectedClassroom.requestTeachers
            complete?()
        }
    }
    
    func updateRequestStudents(complete: EmptyClosure? = nil) {
        TeacherClassroomManageViewModel.selectedClassroom.getRequestStudents() {
            self.requestStudents = TeacherClassroomManageViewModel.selectedClassroom.requestStudents
            complete?()
        }
    }
    
    func getStudentName(at index: Int) -> String {
        let student = self.requestStudents[index]
        return student.account.fullName + " 학생"
    }
    
    func getSchoolInfo(at index: Int) -> String {
        let student = self.requestStudents[index]
        return student.schoolName + " " + "\(String(student.schoolYear))학년"
    }
    
    func getTeacherName(at index: Int) -> String {
        let teacher = self.requestTeachers[index]
        return teacher.account.fullName + " 선생님"
    }
}
