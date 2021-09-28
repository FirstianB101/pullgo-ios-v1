//
//  TeacherCreateLesson_SelectClassroomViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/18.
//

import UIKit

class TeacherCreateLesson_SelectClassroomViewController: UIViewController {

    var selectClassroomDelegate: TeacherCreateLessonDelegate?
    let viewModel = TeacherCreateLesson_SelectClassroomViewModel()
    @IBOutlet weak var classroomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getClassrooms {
            self.classroomTableView.reloadData()
        }
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
        let classroomParse = viewModel.classrooms[indexPath.row].parse
        
        cell.teacherNameLabel.text = classroomParse.teacherName
        cell.weekdayLabel.text = classroomParse.weekday
        cell.classroomNameLabel.text = classroomParse.classroomName
        
        return cell
    }
}

class TeacherCreateLesson_SelectClassroomViewModel {
    var classrooms: [Classroom] = []
    var page: Int = 0
    
    public func getClassrooms(completion: @escaping (() -> Void)) {
        PGSignedUser.getClassrooms(page: page) { classrooms in
            self.classrooms = classrooms
            completion()
        }
    }
}
