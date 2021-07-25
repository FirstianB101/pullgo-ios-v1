//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageRequestViewController: UIViewController, TeacherClassroomManageTopBar, NetworkAlertDelegate {
    
    @IBOutlet weak var classroomName: UILabel!
    @IBOutlet weak var studentCollectionView: UICollectionView!
    let viewModel = TeacherClassroomManageRequestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPromptNameBySelectedClassroom()
        viewModel.networkAlertDelegate = self
        viewModel.updateRequest() {
            self.studentCollectionView.reloadData()
        }
    }
    
    func setPromptNameBySelectedClassroom() {
        classroomName.text = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismissSelectedClassroom()
        self.dismiss(animated: true, completion: nil)
    }
    
    func networkFailAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.presentNetworkError()
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDelegate {
    
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDataSource, Styler {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.requestStudents.count + viewModel.requestTeachers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherClassroomManageRequestCell", for: indexPath) as! TeacherClassroomManageRequestCell
        
        cell.fullName.text = viewModel.getStudentName(at: indexPath.item)
        cell.studentSchoolInfo.text = viewModel.getSchoolInfo(at: indexPath.item)
        setCellUI(cell: cell)
        
        return cell
    }
}

extension TeacherClassroomManageRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 128
        let padding: CGFloat = 10
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
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
}
