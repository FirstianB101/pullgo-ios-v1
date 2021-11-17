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
    
    lazy var deleteExamButton = { () -> UIBarButtonItem in
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteExam(_:)))
    }()
    
    lazy var deleteDoneButton = { () -> UIBarButtonItem in
        UIBarButtonItem(title: "삭제 완료", style: .done, target: self, action: #selector(self.deleteDone(_:)))
    }()
    
    var isDeleting: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setPromptNameBySelectedClassroom()
        setTitleByTabBarMenu()
        setLeftBarItemByDeletingStatus()
        self.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        examListCollection.setCollectionViewBackgroundColor()
    }
    
    func reloadData() {
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
    
    func setLeftBarItemByDeletingStatus() {
        if self.isDeleting {
            self.navigationController?.navigationBar.topItem?.setLeftBarButton(deleteDoneButton, animated: true)
        } else {
            self.navigationController?.navigationBar.topItem?.setLeftBarButton(deleteExamButton, animated: true)
        }
    }
    
    @objc
    func deleteExam(_ sender: UIBarButtonItem) {
        self.isDeleting = true
        setLeftBarItemByDeletingStatus()
        self.examListCollection.reloadData()
    }
    
    @objc
    func deleteDone(_ sender: UIBarButtonItem) {
        self.isDeleting = false
        setLeftBarItemByDeletingStatus()
        self.reloadData()
    }
    
    func forbiddenAlert() {
        let alert = PGAlertPresentor()
        alert.present(title: "알림",
                      context: """
                          시험에 대한 권한이 없습니다.
                          시험을 생성한 선생님에게 요청해보세요.
                          """)
    }
}

extension TeacherClassroomManageExamViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard viewModel.exams[indexPath.item].creatorId == PGSignedUser.id else {
            forbiddenAlert()
            return
        }
        
        if isDeleting {
            deleteExamClicked(at: indexPath)
        } else {
            editExamClicked(at: indexPath)
        }
    }
    
    func deleteExamClicked(at indexPath: IndexPath) {
        
        let alert = PGAlertPresentor()
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteExam(at: indexPath.item, completion: self?.reloadData)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.present(title: "\(viewModel.getExamName(at: indexPath.item))",
                      context: """
                      시험을 정말 삭제할까요?
                      삭제된 시험은 복구할 수 없습니다.
                      """,
                      actions: [cancel, delete])
    }
    
    func editExamClicked(at indexPath: IndexPath) {
        let selectedExam = viewModel.exams[indexPath.item]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherManageExamTabViewController") as? TeacherManageExamTabViewController else { return }
        vc.viewModel.selectedExam = selectedExam
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 138
        let padding: CGFloat = 20
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
    }
}

extension TeacherClassroomManageExamViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherExamListCell", for: indexPath) as! TeacherExamListCell
        
        cell.examNameLabel.text = viewModel.getExamName(at: indexPath.item)
        cell.timeLabel.text = viewModel.getExamTime(at: indexPath.item)
        cell.timeLimitLabel.text = viewModel.getTimeLimit(at: indexPath.item)
        cell.setCellUI()
        
        if self.isDeleting && cell.deleteImage.isHidden {
            cell.deleteImage.isHidden = false
            cell.deleteImage.popUp()
        } else if !self.isDeleting && !cell.deleteImage.isHidden {
            cell.deleteImage.popDown {
                cell.deleteImage.isHidden = true
            }
        }
        
        return cell
    }
}

class TeacherExamListCell: UICollectionViewCell {
    @IBOutlet weak var examNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var deleteImage: UIImageView!
}

class TeacherClassroomManageExamViewModel {
    var exams = [Exam]()
    
    private var page: Int = 0
    
    func getExams(completion: @escaping (() -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom.getExams(page: self.page) { exams in
            self.exams = exams
            completion()
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
    
    func deleteExam(at index: Int, completion: (() -> Void)?) {
        let selectedExam = self.exams[index]
        selectedExam.url = PGURLs.exams
        
        selectedExam.delete(success: { _ in
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "시험이 삭제되었습니다.") { _ in completion?() }
        })
    }
}
