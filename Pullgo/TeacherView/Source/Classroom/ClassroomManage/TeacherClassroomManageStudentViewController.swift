//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

class TeacherClassroomManageStudentViewController: UIViewController, TeacherClassroomManageTopBar {
    
    let viewModel = TeacherClassroomManageStudentViewModel()
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.updateStudents() {
            self.studentTableView.reloadData()
        }
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "학생 관리"
    }
    
    @IBAction func kickStudent(_ sender: UIButton) {
        if viewModel.students.isEmpty {
            let alert = PGAlertPresentor(presentor: self)
            alert.present(title: "알림", context: "내보낼 학생이 없습니다.")
            return
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomKickTeacherViewController") as? TeacherClassroomKickTeacherViewController else { return }
        
        // student 넘겨주기
        vc.viewModel.setStudents(self.viewModel.students)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension TeacherClassroomManageStudentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomDetailStudentViewController") as? TeacherClassroomDetailStudentViewController else { return }
        
        // student 넘겨주기
        vc.viewModel.selectedStudent = viewModel.students[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TeacherClassroomManageStudentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomManageStudentCell") as? TeacherClassroomManageStudentCell else { return UITableViewCell() }
        
        cell.schoolInfoLabel.text = viewModel.getSchoolInfo(at: indexPath.row)
        cell.studentNameLabel.text = viewModel.getStudentName(at: indexPath.row)
        
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
