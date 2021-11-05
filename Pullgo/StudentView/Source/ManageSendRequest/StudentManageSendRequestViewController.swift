//
//  StudentManageSendRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit
import XLPagerTabStrip

class StudentManageSendRequestViewController: ButtonBarPagerTabStripViewController {
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let academyVC = storyboard?.instantiateViewController(withIdentifier: "ManageSendRequestAcademyViewController"),
              let classroomVC = storyboard?.instantiateViewController(withIdentifier: "ManageSendRequestClassroomViewController") else { return [] }
        
        return [academyVC, classroomVC]
    }
    
    override func viewDidLoad() {
        self.setDefaultSettings()
        super.viewDidLoad()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
}
