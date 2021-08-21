//
//  TeacherSelectExamDateViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/06.
//

import UIKit

class TeacherSelectExamDateViewController: UIViewController {

    let viewModel = TeacherSelectExamDateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

class TeacherSelectExamDateViewModel {
    enum DateCase {
        case beginDate
        case endDate
    }
    
    var dateCase: DateCase = .beginDate
}
