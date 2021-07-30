//
//  TeacherCreateClassroomSelectAcademyViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/31.
//

import UIKit

class TeacherCreateClassroomSelectAcademyViewController: UIViewController {
    
    @IBOutlet weak var academyCollectionView: UICollectionView!
    let viewModel = TeacherCreateClassroomSelectAcademyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TeacherCreateClassroomSelectAcademyViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAcademy = viewModel.academies[indexPath.item]
        viewModel.selectAcademyDelegate?.setSelectedAcademy(academy: selectedAcademy)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let width = collectionView.bounds.width - padding * 2
        let height: CGFloat = 68
        
        return CGSize(width: width, height: height)
    }
}

extension TeacherCreateClassroomSelectAcademyViewController: UICollectionViewDataSource, Styler {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.academies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherCreateClassroomSelectAcademyCell", for: indexPath) as! TeacherCreateClassroomSelectAcademyCell
        
        cell.academyNameLabel.text = viewModel.getAcademyName(at: indexPath.item)
        setCellUI(cell: cell)
        
        return cell
    }
}

class TeacherCreateClassroomSelectAcademyViewModel {
    let academies: [Academy] = SignedUser.academies ?? []
    var selectAcademyDelegate: TeacherCreateClassroomSelectAcademyDelegate?
    
    func getAcademyName(at index: Int) -> String {
        return academies[index].name!
    }
}

class TeacherCreateClassroomSelectAcademyCell: UICollectionViewCell {
    @IBOutlet weak var academyNameLabel: UILabel!
}
