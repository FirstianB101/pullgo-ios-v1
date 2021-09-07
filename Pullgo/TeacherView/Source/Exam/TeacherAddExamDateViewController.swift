//
//  TeacherAddExamDateViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/06.
//

import UIKit

class TeacherAddExamDateViewController: UIViewController, Styler {

    @IBOutlet weak var selectBeginDateButton: UIButton!
    @IBOutlet weak var selectEndDateButton: UIButton!
    @IBOutlet weak var createExamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: selectBeginDateButton, radius: 15)
        setViewCornerRadius(view: selectEndDateButton, radius: 15)
        setViewCornerRadius(view: createExamButton)
        setViewShadow(view: selectBeginDateButton)
        setViewShadow(view: selectEndDateButton)
        setViewShadow(view: createExamButton)
    }
    
    @IBAction func selectBeginDate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "datePickerView") as! DatePickerViewController
        
        vc.datePickerMode = .dateWithTimeLimit
        vc.navigationItem.title = "시험 시간 설정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectEndDate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherSelectExamDateViewController") as! TeacherSelectExamDateViewController
        vc.navigationItem.title = "마감 날짜"
        vc.viewModel.dateCase = .endDate
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
