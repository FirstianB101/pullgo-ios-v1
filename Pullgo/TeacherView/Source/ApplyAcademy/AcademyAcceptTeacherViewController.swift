//
//  AcademyAcceptTeacherViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/06.
//

import UIKit
import XLPagerTabStrip

class AcademyAcceptTeacherViewController: UICollectionViewController, IndicatorInfoProvider {
    
    let viewModel = AcademyAcceptTeacherViewModel()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "선생님")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewBackgroundColor()
        self.reload()
    }
    
    public func reload() {
        viewModel.getAppliedTeachers { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getTeacherCount()
    }
    
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcademyAcceptTeacherCell", for: indexPath) as? AcademyAcceptTeacherCell else {
            return UICollectionViewCell()
        }
        
        cell.teacherNameLabel.text = viewModel.getTeacherName(at: indexPath.item)
        cell.acceptButton.setViewCornerRadius(radius: 5)
        cell.accept = { [unowned self] in
            self.acceptClicked(at: indexPath.item)
        }
        cell.setCellUI()
        
        return cell
    }
    
    private func acceptClicked(at index: Int) {
        let alert = PGAlertPresentor(presentor: self)
        let teacherName = self.viewModel.getTeacherName(at: index)
        
        let okay = UIAlertAction(title: "승인", style: .default) { [weak self] _ in
            self?.viewModel.accept(at: index) {
                alert.present(title: "알림", context: "\(teacherName)의 학원 가입이 승인되었어요.")
                self?.reload()
            }
        }
        
        alert.present(title: "알림",
                      context: "\(teacherName)의 가입을 승인할까요?",
                      actions: [alert.cancel, okay])
    }
}

extension AcademyAcceptTeacherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 100
        let padding: CGFloat = 10
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
    }
}

class AcademyAcceptTeacherCell: UICollectionViewCell {
    @IBOutlet weak var teacherNameLabel: UILabel!
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

class AcademyAcceptTeacherViewModel {
    private var teachers: [Teacher] = []
    private var page: Int = 0
    
    public func getTeacherName(at index: Int) -> String {
        return teachers[index].account.fullName + " 선생님"
    }
    
    public func getTeacherCount() -> Int {
        return teachers.count
    }
    
    public func getAppliedTeachers(completion: @escaping (() -> Void)) {
        PGSignedUser.selectedAcademy.getAppliedTeachers(page: self.page) { teachers in
            self.teachers = teachers
            completion()
        }
    }
    
    public func accept(at index: Int, completion: @escaping (() -> Void)) {
        let selectedTeacher = teachers[index]
        
        PGSignedUser.selectedAcademy.accept(userType: .teacher, userId: selectedTeacher.id!) { _ in
            completion()
        }
    }
    
    public func reject(at index: Int, completion: @escaping (() -> Void)) {
        let selectedTeacher = teachers[index]
        
//        PGSignedUser.selectedAcademy.accept(userType: .teacher, userId: selectedTeacher.id!) { _ in
//            completion()
//        }
    }
}
