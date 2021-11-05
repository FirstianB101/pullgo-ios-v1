//
//  TeacherManageAcademyRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/06.
//

import UIKit

class TeacherManageAcademyRequestViewController: UICollectionViewController {
    
    let viewModel = TeacherManageAcademyRequestViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


extension TeacherManageAcademyRequestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let height: CGFloat = 150
        
        return CGSize(width: self.view.frame.width - padding * 2, height: height)
    }
}


class TeacherManageAcademyRequestViewModel {
    
    var academies: [Academy] = []
    
    public func getAcademies(completion: @escaping (() -> Void)) {
        PGSignedUser.getApplyingAcademies(page: <#T##Int#>, completion: <#T##(([Academy]) -> Void)##(([Academy]) -> Void)##([Academy]) -> Void#>)
    }
}
