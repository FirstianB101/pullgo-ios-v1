//
//  TeacherAddExamDateViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/06.
//

import UIKit

class TeacherAddExamDateViewController: UIViewController {

    @IBOutlet weak var selectBeginDateButton: PGSelectButton!
    @IBOutlet weak var selectEndDateButton: PGSelectButton!
    @IBOutlet weak var createExamButton: PGButton!
    
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
    
    @IBAction func createLesson(_ sender: PGButton) {
        let url = NetworkManager.assembleURL("exams")
        let alert = PGAlertPresentor(presentor: self)
        
        let success: ResponseClosure = { _ in
            let okay = UIAlertAction(title: "예", style: .default) { _ in
                
            }
            let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            alert.present(title: createdExam.name, context: "시험이 생성되었습니다.\n문제를 바로 출제하시겠어요?", actions: [cancel, okay])
        }
        
        let fail: FailClosure = {
            alert.presentNetworkError()
        }
        
        NetworkManager.post(url: url, data: createdExam, success: success, fail: fail, complete: nil)
    }
}

extension TeacherAddExamDateViewController: DatePickerViewDelegate {
    
    func datePickerView(_ sender: PGSelectButton?, date: Date, time: Date) {
        let mergedDate = createdExam.mergeDateAndTime(date: date, time: time)
        let title = date.toString(format: "YYYY년 MM월 dd일")
        let subtitle = time.toString(format: "HH시 mm분")
        
        if sender == selectBeginDateButton {
            createdExam.beginDateTime = mergedDate
            selectButtonSelected(sender, title: title, subtitle: subtitle)
        } else if sender == selectEndDateButton {
            createdExam.endDateTime = mergedDate
            selectButtonSelected(sender, title: title, subtitle: subtitle)
        }
    }
    
    private func selectButtonSelected(_ sender: PGSelectButton?, title: String, subtitle: String) {
        sender?.setSelectedTitle(title)
        sender?.setSelectedSubtitle(subtitle)
        sender?.setState(for: .selected)
    }
}
