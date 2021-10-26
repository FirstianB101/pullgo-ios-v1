//
//  TeacherRemoveExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/23.
//

import UIKit
import XLPagerTabStrip

class TeacherRemoveExamViewController: UIViewController, IndicatorInfoProvider {
    
    var viewModel: TeacherManageExamViewModel
    
    init?(coder: NSCoder, viewModel: TeacherManageExamViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("TeacherRemoveExamViewController: viewModel is nil.")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "취소 및 삭제")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
