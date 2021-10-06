//
//  TeacherApplyAcademyJoinRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/06.
//

import UIKit
import XLPagerTabStrip

class TeacherApplyAcademyJoinRequestViewController: ButtonBarPagerTabStripViewController {
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        guard let teacherView = storyboard?.instantiateViewController(withIdentifier: "AcademyAcceptTeacherViewController"),
              let studentView = storyboard?.instantiateViewController(withIdentifier: "AcademyAcceptStudentViewController") else { return [] }
        
        return [teacherView, studentView]
    }
    
    override func viewDidLoad() {
        self.setDefaultSettings()
        if let color = UIColor(named: "CollectionViewBackground") {
            self.containerView.backgroundColor = color
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }
}
