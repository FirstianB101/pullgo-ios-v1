//
//  TeacherAddExamDateViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/06.
//

import UIKit

class TeacherAddExamDateViewController: UIViewController, Styler {

    @IBOutlet weak var selectBeginDateButton: PGSelectButton!
    @IBOutlet weak var selectEndDateButton: PGSelectButton!
    @IBOutlet weak var createExamButton: PGButton!
    
    let viewModel = TeacherAddExamDateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeselectTitle()
    }
    
    func setDeselectTitle() {
        selectBeginDateButton.setDeselectedTitle("시작 날짜를 선택해주세요.")
        selectEndDateButton.setDeselectedTitle("마감 날짜를 선택해주세요.")
    }
    
    @IBAction func selectBeginDate(_ sender: PGSelectButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "datePickerView") as! DatePickerViewController
        
        vc.datePickerMode = .dateWithTimeLimit
        vc.delegate = self
        vc.sender = sender
        vc.navigationItem.title = "시작 날짜 설정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectEndDate(_ sender: PGSelectButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "datePickerView") as! DatePickerViewController
        
        vc.datePickerMode = .dateWithTimeLimit
        vc.delegate = self
        vc.sender = sender
        vc.navigationItem.title = "마감 날짜 설정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TeacherAddExamDateViewController: DatePickerViewDelegate {
    
    func datePickerView(_ sender: PGSelectButton?, date: Date, time: Date) {
        let mergedDate = viewModel.mergeDateAndTime(date: date, time: time)
        let title = date.toString(format: "YYYY년 MM월 dd일")
        let subtitle = time.toString(format: "HH시 mm분")
        
        if sender == selectBeginDateButton {
            viewModel.startDate = mergedDate
            selectButtonSelected(sender, title: title, subtitle: subtitle)
        } else if sender == selectEndDateButton {
            viewModel.endDate = mergedDate
            selectButtonSelected(sender, title: title, subtitle: subtitle)
        }
    }
    
    private func selectButtonSelected(_ sender: PGSelectButton?, title: String, subtitle: String) {
        sender?.setSelectedTitle(title)
        sender?.setSelectedSubtitle(subtitle)
        sender?.setState(for: .selected)
    }
}

class TeacherAddExamDateViewModel {
    var startDate: String!
    var endDate: String!
    
    func mergeDateAndTime(date: Date, time: Date) -> String {
        var merge = date.toString()
        merge.append("T")
        merge.append(time.toString(format: "HH:mm:ss"))
        
        return merge
    }
}
