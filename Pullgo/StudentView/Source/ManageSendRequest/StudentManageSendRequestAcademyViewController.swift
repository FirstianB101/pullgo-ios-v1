//
//  StudentManageSendRequestAcademyViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/12.
//

import UIKit
import XLPagerTabStrip

class StudentManageSendRequestAcademyViewController: UICollectionViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "학원")
    }
    
    let viewModel = StudentManageSendRequestAcademyViewModel()
    
    override func viewDidLoad() {
        self.collectionView.setCollectionViewBackgroundColor()
        super.viewDidLoad()
        viewModel.getAcademies { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func reload() {
        viewModel.getAcademies { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getAcademies().count
    }
    
    // DataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageSendRequestCell", for: indexPath) as? ManageSendRequestCell else { return UICollectionViewCell() }
        
        let academy = viewModel.getAcademy(at: indexPath.item)
        cell.title.text = academy.name
        cell.subtitle.text = academy.address
        cell.cancel = { [weak self] in
            self?.removeApplyingAcademy(at: indexPath.item, completion: {
                self?.reload()
            })
        }
        cell.setCellUI()
        
        return cell
    }
    
    private func removeApplyingAcademy(at index: Int, completion: @escaping (() -> Void)) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "요청 취소", style: .default) { [weak self] _ in
            self?.viewModel.removeApplyingAcademy(at: index, completion: {
                alert.present(title: "알림", context: "요청 취소가 완료되었습니다.")
                completion()
            })
        }
        
        alert.present(title: "알림",
                      context: "학원에 보낸 요청을 취소하시겠어요?",
                      actions: [alert.cancel, okay])
    }
}

extension StudentManageSendRequestAcademyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let height: CGFloat = 115
        
        return CGSize(width: self.view.frame.width - padding * 2, height: height)
    }
}

class StudentManageSendRequestAcademyViewModel {
    
    private var academies: [Academy] = []
    private var page: Int = 0
    
    public func getAcademies(completion: @escaping (() -> Void)) {
        PGSignedUser.getApplyingAcademies(page: page) { academies in
            self.academies = academies
            completion()
        }
    }
    
    public func getAcademies() -> [Academy] {
        return self.academies
    }
    
    public func getAcademy(at index: Int) -> Academy {
        return self.academies[index]
    }
    
    public func removeApplyingAcademy(at index: Int, completion: @escaping (() -> Void)) {
        let academyId = self.academies[index].id!
        PGSignedUser.removeApplyAcademy(academyId: academyId) { _ in
            completion()
        }
    }
}
