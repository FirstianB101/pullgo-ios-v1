//
//  TeacherClassroomManageViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/16.
//

import UIKit

class TeacherClassroomManageViewController: UIViewController {

    let viewModel = TeacherClassroomManageViewModel()
    @IBOutlet weak var classroomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getClassroom()
    }
    
    public func getClassroom() {
        viewModel.getClassroom {
            self.classroomTableView.reloadData()
        }
    }

    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }
}

extension TeacherClassroomManageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TeacherClassroomManageViewModel.selectedClassroom = viewModel.classrooms[indexPath.row]
        presentClassroomManageView()
    }
    
    func presentClassroomManageView() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherClassroomDetailTab") else { return }
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension TeacherClassroomManageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.classrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassroomCell") as! ClassroomCell
        let classroomNameParse = viewModel.classrooms[indexPath.row].parse
        
        cell.teacherNameLabel.text = classroomNameParse.teacherName
        cell.classroomNameLabel.text = classroomNameParse.classroomName
        cell.weekdayLabel.text = classroomNameParse.weekday
        
        return cell
    }
}

class ClassroomCell: UITableViewCell {
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
}

class TeacherClassroomManageViewModel {
    var classrooms: [Classroom] = []
    static var selectedClassroom: Classroom!
    
    private var page: Int = 0
    
    public func getClassroom(completion: @escaping (() -> Void)) {
        PGSignedUser.getClassrooms(page: self.page) { classrooms in
            self.classrooms = classrooms
            completion()
        }
    }
}
