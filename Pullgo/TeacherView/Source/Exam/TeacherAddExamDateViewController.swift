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
    @IBOutlet weak var createExamButton: PGButton!
    
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "datePickerView") as! DatePickerViewController
        
        vc.datePickerMode = .dateWithTimeLimit
        vc.navigationItem.title = "시작 날짜 설정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectEndDate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "datePickerView") as! DatePickerViewController
        
        vc.datePickerMode = .dateWithTimeLimit
        vc.navigationItem.title = "마감 날짜 설정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TeacherAddExamDateViewController: DatePickerViewDelegate {
    
    
}
