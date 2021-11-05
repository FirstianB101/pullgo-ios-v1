//
//  StudentManageSendRequestClassroomViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/12.
//

import UIKit
import XLPagerTabStrip

class ManageSendRequestClassroomViewController: UICollectionViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "반")
    }
    
    let viewModel = StudentManageSendRequestClassroomViewModel()
    
    override func viewDidLoad() {
        self.collectionView.setCollectionViewBackgroundColor()
        super.viewDidLoad()
        viewModel.getClassrooms { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func reload() {
        viewModel.getClassrooms { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getClassrooms().count
    }
    
    // DataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageSendRequestCell", for: indexPath) as? ManageSendRequestCell else { return UICollectionViewCell() }
        
        let classroomInfo = viewModel.getClassroom(at: indexPath.item)
        cell.title.text = classroomInfo.creator.account.fullName + " 선생님"
        cell.subtitle.text = classroomInfo.parse.weekday + "요일"
        cell.body.text = classroomInfo.parse.classroomName
        cell.cancel = { [weak self] in
            self?.removeApplyingClassroom(at: indexPath.item, completion: {
                self?.reload()
            })
        }
        cell.setCellUI()
        
        return cell
    }
    
    private func removeApplyingClassroom(at index: Int, completion: @escaping (() -> Void)) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "요청 취소", style: .default) { [weak self] _ in
            self?.viewModel.removeApplyingClassroom(at: index, completion: {
                alert.present(title: "알림", context: "요청 취소가 완료되었습니다.")
                completion()
            })
        }
        
        alert.present(title: "알림",
                      context: "반에 보낸 요청을 취소하시겠어요?",
                      actions: [alert.cancel, okay])
    }
}

extension ManageSendRequestClassroomViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let height: CGFloat = 150
        
        return CGSize(width: self.view.frame.width - padding * 2, height: height)
    }
}

class StudentManageSendRequestClassroomViewModel {
    
    private var classrooms: [Classroom] = []
    private var page: Int = 0
    
    public func getClassrooms(completion: @escaping (() -> Void)) {
        PGSignedUser.getApplyingClassrooms(page: page) { classrooms in
            self.classrooms = classrooms
            completion()
        }
    }
    
    public func getClassrooms() -> [Classroom] {
        return self.classrooms
    }
    
    public func getClassroom(at index: Int) -> Classroom {
        return self.classrooms[index]
    }
    
    public func removeApplyingClassroom(at index: Int, completion: @escaping (() -> Void)) {
        let classroomId = self.classrooms[index].id!
        PGSignedUser.removeApplyClassroom(classroomId: classroomId) { _ in
            completion()
        }
    }
}
