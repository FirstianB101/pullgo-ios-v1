//
//  TeacherClassroomKickTeacherViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/03.
//

import UIKit
import SnapKit
import RxSwift

class TeacherClassroomKickTeacherViewController: UIViewController {
    @IBOutlet weak var studentTableView: UITableView!
    @IBOutlet weak var kickStudentButton: UIButton!
    
    let uncheckImage = UIImage(systemName: "circle")!
    let checkImage = UIImage(systemName: "checkmark.circle.fill")!
    let viewModel = TeacherClassroomKickTeacherViewModel()
    
    let allSelectTitle = "전체 선택"
    let allDeselectTitle = "전체 해제"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kickStudentButton.setTitle("선택한 학생 내보내기", for: .normal)
        self.addToggleAllStatusButton()
    }
    
    private func addToggleAllStatusButton() {
        let toggleAllStatusButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(toggleAllStatus(_:)))
        
        toggleAllStatusButton.title = allSelectTitle
        self.navigationItem.rightBarButtonItem = toggleAllStatusButton
    }
    
    @objc func toggleAllStatus(_ sender: UIBarButtonItem) {
        // 문구가 [전체 선택]일 경우
        if sender.title == allSelectTitle {
            sender.title = allDeselectTitle
            viewModel.changeAllStatus(to: true)
        }
        // 문구가 [전체 해제]일 경우
        else {
            sender.title = allSelectTitle
            viewModel.changeAllStatus(to: false)
        }
        
        self.studentTableView.reloadData()
    }
    
    @IBAction func kickStudents(_ sender: PGButton) {
        let alert = PGAlertPresentor(presentor: self)
        let selectedCount = viewModel.getSelectedStudents().count
        
        if selectedCount == 0 {
            alert.present(title: "알림", context: "선택한 학생이 없습니다.")
            return
        }
        
        let okay = UIAlertAction(title: "확인", style: .default) { _ in
//            self.viewModel.kickStudents()
        }
        
        alert.present(title: "학생 내보내기",
                      context: "선택한 학생 \(selectedCount)명을 반에서 내보냅니다.",
                      actions: [alert.cancel, okay])
    }
    
}

extension TeacherClassroomKickTeacherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleStudentSelectState(at: indexPath.row)
        tableView.reloadData()
    }
}

extension TeacherClassroomKickTeacherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomKickCell") as? TeacherClassroomKickCell else { return UITableViewCell() }
        
        cell.schoolInfoLabel.text = viewModel.getSchoolInfo(at: indexPath.row)
        cell.schoolNameLabel.text = viewModel.getStudentName(at: indexPath.row)
        cell.selecteStateImage.image = viewModel.getSelectedStatus(at: indexPath.row) ? self.checkImage : self.uncheckImage
        
        return cell
    }
}

class TeacherClassroomKickCell: UITableViewCell {
    @IBOutlet weak var selecteStateImage: UIImageView!
    @IBOutlet weak var schoolInfoLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
}

class TeacherClassroomKickTeacherViewModel {
    var students: [(selected: Bool, student: Student)] = []
    
    public func setStudents(_ students: [Student]) {
        for student in students {
            self.students.append((false, student))
        }
    }
    
    public func getSelectedStatus(at index: Int) -> Bool {
        return self.students[index].selected
    }
    
    public func toggleStudentSelectState(at index: Int) {
        self.students[index].selected = !self.students[index].selected
    }
    
    public func getSchoolInfo(at index: Int) -> String {
        let student = self.students[index].student
        return "\(student.schoolName!) \(student.schoolYear!)학년"
    }
    
    public func getStudentName(at index: Int) -> String {
        let student = self.students[index].student
        return student.account.fullName + " 학생"
    }
    
    public func changeAllStatus(to status: Bool) {
        for (index, _) in students.enumerated() {
            self.students[index].selected = status
        }
    }
    
    public func getSelectedStudents() -> [Student] {
        return self.students.filter { $0.selected == true }.map { $0.student }
    }
    
    public func kickStudents(completion: @escaping (() -> Void)) {
        Observable.from(self.getSelectedStudents())
            .compactMap({ $0.id })
            .subscribe(onNext: { id in
                self.kickStudent(id: id)
            }, onDisposed: {
                completion()
            })
            .dispose()
    }
    
    private func kickStudent(id: Int) {
        TeacherClassroomManageViewModel.selectedClassroom.kick(userType: .student,
                                                               userId: id)
    }
}
