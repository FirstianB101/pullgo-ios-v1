//
//  TeacherExamEditViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/23.
//

import UIKit
import XLPagerTabStrip

class TeacherExamEditViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수정")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
