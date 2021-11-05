//
//  TeacherManageClassroomRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/06.
//

import UIKit

class TeacherManageClassroomRequestViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TeacherManageClassroomRequestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let height: CGFloat = 150
        
        return CGSize(width: self.view.frame.width - padding * 2, height: height)
    }
}
