//
//  ClassroomAcceptTeacherViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/11.
//

import UIKit
import XLPagerTabStrip

class ClassroomAcceptTeacherViewController: UICollectionViewController, IndicatorInfoProvider {

    
    let viewModel = ClassroomAcceptTeacherViewModel()
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcceptTeacherCell", for: indexPath) as? AcceptTeacherCell else {
            return UICollectionViewCell()
        }
        
        cell.teacherNameLabel.text = viewModel.getTeacherName(at: indexPath.item)
        cell.acceptButton.setViewCornerRadius(radius: 5)
        cell.accept = { [unowned self] in
            self.acceptClicked(at: indexPath.item)
        }
        cell.reject = { [unowned self] in
            self.rejectClicked(at: indexPath.item)
        }
        cell.setCellUI()
        
        return cell
    }
    
    private func acceptClicked(at index: Int) {
        let alert = PGAlertPresentor(presentor: self)
        let teacherName = self.viewModel.getTeacherName(at: index)
        
        let okay = UIAlertAction(title: "승인", style: .default) { [weak self] _ in
            self?.viewModel.accept(at: index) {
                alert.present(title: "알림", context: "\(teacherName)의 반 가입이 승인되었어요.")
                self?.reload()
            }
        }
        
        alert.present(title: "알림",
                      context: "\(teacherName)의 가입을 승인할까요?",
                      actions: [alert.cancel, okay])
    }
    
    private func rejectClicked(at index: Int) {
        let alert = PGAlertPresentor(presentor: self)
        let teacherName = self.viewModel.getTeacherName(at: index)
        
        let reject = UIAlertAction(title: "거절", style: .default) { [weak self] _ in
            self?.viewModel.reject(at: index) {
                alert.present(title: "알림", context: "\(teacherName)의 요청이 거절되었어요.")
                self?.reload()
            }
        }
        
        alert.present(title: "알림",
                      context: "\(teacherName)의 요청을 거절할까요?",
                      actions: [alert.cancel, reject])
    }
}

extension ClassroomAcceptTeacherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 100
        let padding: CGFloat = 20
        let width = collectionView.bounds.width - padding * 2
        
        return CGSize(width: width, height: height)
    }
}

class ClassroomAcceptTeacherViewModel {
    private var teachers: [Teacher] = []
    private var page: Int = 0
    
    public func getTeacherName(at index: Int) -> String {
        return teachers[index].account.fullName + " 선생님"
    }
    
    public func getTeacherCount() -> Int {
        return teachers.count
    }
    
    public func getAppliedTeachers(completion: @escaping (() -> Void)) {
        TeacherClassroomManageViewModel.selectedClassroom.getAppliedTeachers(page: self.page) { teachers in
            self.teachers = teachers
            completion()
        }
    }
    
    public func accept(at index: Int, completion: @escaping (() -> Void)) {
        let selectedTeacher = teachers[index]
        
        TeacherClassroomManageViewModel.selectedClassroom.accept(userType: .teacher, userId: selectedTeacher.id!) { _ in
            completion()
        }
    }
    
    public func reject(at index: Int, completion: @escaping (() -> Void)) {
        let selectedTeacher = teachers[index]
        let url = PGURLs.teachers.appendingURL([String(selectedTeacher.id!), "remove-applied-classroom"])
        
        let body: Parameter = ["classroomId" : TeacherClassroomManageViewModel.selectedClassroom.id!]
        
        PGNetwork.post(url: url, parameter: body, success: { _ in
            completion()
        })
    }
}
