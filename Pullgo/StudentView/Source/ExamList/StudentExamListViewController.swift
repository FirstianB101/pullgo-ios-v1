//
//  StudentExamListViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentExamListViewController: UIViewController {
    
    @IBOutlet weak var examList: UICollectionView!
    
    let viewModel = StudentExamListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        examList.setCollectionViewBackgroundColor()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
}

extension StudentExamListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let height: CGFloat = 165
        
        return CGSize(width: self.view.bounds.width - padding * 2, height: height)
    }
}

extension StudentExamListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getExams().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? StudentExamListCell else { return UICollectionViewCell() }
        
        let exam = viewModel.getExam(at: indexPath.item)
        exam.getAcademyAndClassroom { academy, classroom in
            cell.academyAndClassroomLabel.text = academy.name + " " + classroom.name
        }
        cell.examNameLabel.text = exam.name
        cell.timeLimitLabel.text = exam.getTimeLimit()
        cell.beginAndEndDateLabel.text = exam.getBeginDateTime() + " ~ " + exam.getEndDateTime()
        cell.setCellUI()
        
        return cell
    }
}

class StudentExamListCell: UICollectionViewCell {
    @IBOutlet weak var academyAndClassroomLabel: UILabel!
    @IBOutlet weak var examNameLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var beginAndEndDateLabel: UILabel!
}

class StudentExamListViewModel {
    
    private var exams: [Exam] = []
    private var page: Int = 0
    
    public func getExams(completion: @escaping (() -> Void)) {
        PGSignedUser.getExams(page: page) { exams in
            self.exams = exams
            completion()
        }
    }
    
    public func getExams() -> [Exam] {
        return self.exams
    }
    
    public func getExam(at index: Int) -> Exam {
        return self.exams[index]
    }
}
