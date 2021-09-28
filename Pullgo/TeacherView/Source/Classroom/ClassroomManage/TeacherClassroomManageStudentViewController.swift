//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageStudentViewController: UIViewController, TeacherClassroomManageTopBar {
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "학생 관리"
    }

    let viewModel = TeacherClassroomManageStudentViewModel()
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.updateStudents() {
            self.studentTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TeacherClassroomManageStudentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomDetailStudentViewController") else { return }
        
        // student 넘겨주기
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TeacherClassroomManageStudentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomManageStudentCell", for: indexPath) as! TeacherClassroomManageStudentCell
        
        cell.schoolInfoLabel.text = viewModel.getSchoolInfo(at: indexPath.item)
        cell.studentNameLabel.text = viewModel.getStudentName(at: indexPath.item)
        
        return cell
    }
    
}

class TeacherClassroomManageStudentCell: UITableViewCell {
    @IBOutlet weak var schoolInfoLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
}

class TeacherClassroomManageStudentViewModel {
    var students = [Student]()
    
    private var page: Int = 0
    
    func updateStudents(completion: @escaping (() -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom.getStudents(page: page) { students in
            self.students = students
            completion()
        }
    }
    
    func getSchoolInfo(at index: Int) -> String {
        let student = students[index]
        let school = student.schoolName!
        let year = "\(student.schoolYear!)학년"
        
        return school + " " + year
    }
    
    func getStudentName(at index: Int) -> String {
        return students[index].account.fullName
    }
}
