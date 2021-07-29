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
    @IBOutlet weak var studentsCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.updateStudents() {
            self.studentsCollectionView.reloadData()
        }
    }
}

extension TeacherClassroomManageStudentViewController: UICollectionViewDelegate {
    
}

extension TeacherClassroomManageStudentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherClassroomManageStudentCell", for: indexPath) as! TeacherClassroomManageStudentCell
        
        cell.schoolInfoLabel.text = viewModel.getSchoolInfo(at: indexPath.item)
        cell.studentNameLabel.text = viewModel.getStudentName(at: indexPath.item)
        
        return cell
    }
    
    
}

class TeacherClassroomManageStudentCell: UICollectionViewCell {
    @IBOutlet weak var schoolInfoLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
}

class TeacherClassroomManageStudentViewModel {
    var students = [Student]()
    
    func updateStudents(complete: EmptyClosure? = nil) {
        TeacherClassroomManageViewModel.selectedClassroom.getStudents() {
            self.students = TeacherClassroomManageViewModel.selectedClassroom.students
            complete?()
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
