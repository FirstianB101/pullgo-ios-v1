//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageRequestViewController: UIViewController, TeacherClassroomManageTopBar, NetworkAlertDelegate {
    
    @IBOutlet weak var classroomName: UILabel!
    @IBOutlet weak var requestCollectionView: UICollectionView!
    @IBOutlet weak var userTypeSegment: UISegmentedControl!
    let viewModel = TeacherClassroomManageRequestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSegmentUI()
        setPromptNameBySelectedClassroom()
        viewModel.networkAlertDelegate = self
        viewModel.updateRequest() {
            self.requestCollectionView.reloadData()
        }
    }
    
    func setPromptNameBySelectedClassroom() {
        classroomName.text = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    func setSegmentUI() {
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismissSelectedClassroom()
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func deleteRequest(_ sender: UIButton) {
        
    }
    
    @IBAction func applyRequest(_ sender: UIButton) {
        
    }
}

class TeacherClassroomManageRequestViewModel {
    var requestStudents: [Student] = []
    var requestTeachers: [Teacher] = []
    var networkAlertDelegate: NetworkAlertDelegate?
    var userType: UserType = .student
    
    func updateRequest(complete: EmptyClosure? = nil) {
        updateRequestTeachers(complete: complete)
        updateRequestStudents(complete: complete)
    }
    
    func updateRequestTeachers(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("teachers")
        url.appendQuery(query: URLQueryItem(name: "appliedClassroomId", value: String(TeacherClassroomManageViewModel.selectedClassroom.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedRequestTeachers = try? data?.toObject(type: [Teacher].self) else {
                fatalError("TeacherClassroomManageRequestViewModel.updateRequestTeachers() -> data parse error")
            }
            self.requestTeachers = receivedRequestTeachers
        }
        
        let fail: EmptyClosure = { self.networkAlertDelegate?.networkFailAlert() }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    func updateRequestStudents(complete: EmptyClosure? = nil) {
        var url = NetworkManager.assembleURL("students")
        url.appendQuery(query: URLQueryItem(name: "appliedClassroomId", value: String(TeacherClassroomManageViewModel.selectedClassroom.id!)))
        
        let success: ResponseClosure = { data in
            guard let receivedRequestStudents = try? data?.toObject(type: [Student].self) else {
                fatalError("TeacherClassroomManageRequestViewModel.updateRequestStudents() -> data parse error")
            }
            self.requestStudents = receivedRequestStudents
        }
        
        let fail: EmptyClosure = { self.networkAlertDelegate?.networkFailAlert() }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
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
