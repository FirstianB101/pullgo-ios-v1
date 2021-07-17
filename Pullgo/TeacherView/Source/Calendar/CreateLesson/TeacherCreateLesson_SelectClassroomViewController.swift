//
//  TeacherCreateLesson_SelectClassroomViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/18.
//

import UIKit

class TeacherCreateLesson_SelectClassroomViewController: UIViewController, NetworkAlertDelegate {

    var selectClassroomDelegate: TeacherCreateLessonDelegate?
    let viewModel = TeacherCreateLesson_SelectClassroomViewModel()
    @IBOutlet weak var classroomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignedUser.networkAlertDelegate = self
        SignedUser.getClassroomInfo() {
            self.viewModel.getClassroomInfoFromSignedUser()
            self.classroomTableView.reloadData()
            if self.viewModel.classrooms.isEmpty {
                let alert = AlertPresentor(view: self)
                alert.present(title: "알림", context: "속한 반이 없습니다.\n반 가입 요청을 통해 반을 가입해보세요.")
            }
        }
    }
    
    func networkFailAlert() {
        let alert = AlertPresentor(view: self)
        alert.presentNetworkError()
    }
}

extension TeacherCreateLesson_SelectClassroomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClassroom = viewModel.classrooms[indexPath.row]
        self.selectClassroomDelegate?.updateSelectedClassroom(selected: selectedClassroom)
        self.selectClassroomDelegate?.updateSelectedClassroomButtonLabel()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension TeacherCreateLesson_SelectClassroomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.classrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomCell") as! TeacherClassroomCell
        let classroomParse = viewModel.classrooms[indexPath.row].parseClassroomName()
        
        cell.teacherNameLabel.text = classroomParse.teacherName
        cell.weekdayLabel.text = classroomParse.weekday
        cell.classroomNameLabel.text = classroomParse.classroomName
        
        return cell
    }
}

class TeacherCreateLesson_SelectClassroomViewModel {
    var networkAlertDelegate: NetworkAlertDelegate?
    var classrooms: [Classroom] = []
    
    func getClassroomInfoFromSignedUser() {
        classrooms = SignedUser.classrooms ?? []
    }
}
