//
//  AcademyAcceptStudentViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/06.
//

import UIKit
import XLPagerTabStrip

class AcademyAcceptStudentViewController: UICollectionViewController, IndicatorInfoProvider {
    
    let viewModel = AcademyAcceptStudentViewModel()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "학생")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewBackgroundColor()
        self.reload()
    }
    
    public func reload() {
        viewModel.getAppliedStudents { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getStudentCount()
    }
    
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcceptStudentCell", for: indexPath) as? AcceptStudentCell else {
            return UICollectionViewCell()
        }
        
        cell.studentSchoolInfoLabel.text = viewModel.getStudentSchoolInfo(at: indexPath.item)
        cell.studentNameLabel.text = viewModel.getStudentName(at: indexPath.item)
        cell.acceptButton.setViewCornerRadius(radius: 5)
        cell.accept = { [unowned self] in
            self.acceptClicked(at: indexPath.item)
        }
        cell.setCellUI()
        
        return cell
    }
    
    private func acceptClicked(at index: Int) {
        let alert = PGAlertPresentor(presentor: self)
        let studentName = self.viewModel.getStudentName(at: index)
        
        let okay = UIAlertAction(title: "승인", style: .default) { [weak self] _ in
            self?.viewModel.accept(at: index) {
                alert.present(title: "알림", context: "\(studentName)의 학원 가입이 승인되었어요.")
                self?.reload()
            }
        }
        
        alert.present(title: "알림",
                      context: "\(studentName)의 가입을 승인할까요?",
                      actions: [alert.cancel, okay])
    }
}

extension AcademyAcceptStudentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 115
        let padding: CGFloat = 20
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
    }
}

class AcceptStudentCell: UICollectionViewCell {
    @IBOutlet weak var studentSchoolInfoLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    public var accept: (() -> ()) = { }
    public var reject: (() -> ()) = { }
    
    @IBAction func acceptClicked(_ sender: UIButton) {
        self.accept()
    }
    
    @IBAction func rejectClicked(_ sender: UIButton) {
        self.reject()
    }
}

class AcademyAcceptStudentViewModel {
    private var students: [Student] = []
    private var page: Int = 0
    
    public func getStudentSchoolInfo(at index: Int) -> String {
        return students[index].getSchoolInfo()
    }
    
    public func getStudentName(at index: Int) -> String {
        return students[index].account.fullName + " 학생"
    }
    
    public func getStudentCount() -> Int {
        return students.count
    }
    
    public func getAppliedStudents(completion: @escaping (() -> Void)) {
        PGSignedUser.selectedAcademy.getAppliedStudents(page: self.page) { students in
            self.students = students
            completion()
        }
    }
    
    public func accept(at index: Int, completion: @escaping (() -> Void)) {
        let selectedStudent = students[index]
        
        PGSignedUser.selectedAcademy.accept(userType: .student, userId: selectedStudent.id!) { _ in
            completion()
        }
    }
    
    public func reject(at index: Int, completion: @escaping (() -> Void)) {
        let selectedStudent = students[index]
        
    }
}
