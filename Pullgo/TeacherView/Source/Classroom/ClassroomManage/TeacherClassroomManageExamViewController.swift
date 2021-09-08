//
//  TeacherClassroomManageExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/24.
//

import UIKit

protocol TeacherClassroomManageTopBar {
    func setPromptNameBySelectedClassroom()
    func dismissSelectedClassroom()
    func setTitleByTabBarMenu()
}

extension TeacherClassroomManageTopBar {
    func dismissSelectedClassroom() {
        TeacherClassroomManageViewModel.selectedClassroom = nil
    }
}

class TeacherClassroomManageExamViewController: UIViewController, TeacherClassroomManageTopBar {
    let viewModel = TeacherClassroomManageExamViewModel()
    @IBOutlet weak var examListCollection: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        viewModel.getExams {
            self.examListCollection.reloadData()
        }
    }
    
    func setTitleByTabBarMenu() {
        self.navigationController?.navigationBar.topItem?.title = "시험 관리"
    }
    
    func setPromptNameBySelectedClassroom() {
        self.navigationController?.navigationBar.topItem?.prompt = TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName
    }
}

extension TeacherClassroomManageExamViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 138
        let padding: CGFloat = 10
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
    }
}

extension TeacherClassroomManageExamViewController: UICollectionViewDataSource, Styler {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherExamListCell", for: indexPath) as! TeacherExamListCell
        
        cell.examNameLabel.text = viewModel.getExamName(at: indexPath.item)
        cell.timeLabel.text = viewModel.getExamTime(at: indexPath.item)
        cell.timeLimitLabel.text = viewModel.getTimeLimit(at: indexPath.item)
        setCellUI(cell: cell)
        
        return cell
    }
}

class TeacherExamListCell: UICollectionViewCell {
    @IBOutlet weak var examNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
}

class TeacherClassroomManageExamViewModel {
    var exams = [Exam]()
    
    func getExams(complete: @escaping EmptyClosure) {
        TeacherClassroomManageViewModel.selectedClassroom.getExams() {
            self.exams = TeacherClassroomManageViewModel.selectedClassroom.exams
            complete()
        }
    }
    
    func getExamName(at index: Int) -> String {
        guard let examName = self.exams[index].name else { return "" }
        return examName
    }
    
    func getExamTime(at index: Int) -> String {
        let beginTime = self.exams[index].getBeginDateTime()
        let endTime = self.exams[index].getEndDateTime()
        
        return beginTime + " ~ " + endTime
    }
    
    func getTimeLimit(at index: Int) -> String {
        let timeLimit = self.exams[index].getTimeLimit()
        
        return "제한 시간: " + timeLimit
    }
}
