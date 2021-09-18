//
//  TeacherAddExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/05.
//

import UIKit

class TeacherAddExamViewController: UIViewController, Styler {

    @IBOutlet weak var examNameField: UITextField!
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var minuteField: UITextField!
    @IBOutlet weak var passScoreField: UITextField!
    @IBOutlet weak var nextButton: PGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldUI()
        setButtonUI()
        self.setKeyboardWatcher()
    }

    func setTextFieldUI() {
        setTextFieldBorderUnderline(fields: examNameField, hourField, minuteField, passScoreField)
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: nextButton)
        setViewShadow(view: nextButton)
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        guard let examName = examNameField.text,
              let hour = hourField.text,
              let minute = minuteField.text,
              let passScore = passScoreField.text else { return }
        
        if !checkEmptyField() {
            createdExam.updateExamName(name: examName)
            createdExam.updateTimeLimit(hour: hour, minute: minute)
            createdExam.updatePassScore(score: passScore)
            
            presentNextVC()
        }
    }
    
    func checkEmptyField() -> Bool {
        if examNameField.text!.isEmpty {
            alertEmpty(content: "시험 이름을")
        } else if hourField.text!.isEmpty {
            alertEmpty(content: "제한 시간(시간)을")
        } else if minuteField.text!.isEmpty {
            alertEmpty(content: "제한 시간(분)을")
        } else if passScoreField.text!.isEmpty {
            alertEmpty(content: "기준 점수를")
        } else {
            return false
        }
        return true
    }
    
    func alertEmpty(content: String) {
        let alert = PGAlertPresentor(presentor: self)
        alert.present(title: "경고", context: "\(content) 입력해주세요.")
    }
    
    func presentNextVC() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherAddExamDateViewController") else { return }
        
        vc.navigationItem.title = "시험 날짜"
        vc.navigationItem.backButtonTitle = "시험 날짜"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addScoreSuffix(_ sender: UITextField) {
        if !sender.text!.contains("점") {
            sender.text?.append("점")
        } else {
            let lastInput = sender.text?.removeLast()
            sender.text?.removeLast()
            sender.text?.append("\(lastInput!)점")
        }
    }
}

let createdExam = TeacherAddExamViewModel.default

class TeacherAddExamViewModel: Codable {
    static let `default` = TeacherAddExamViewModel()
    
    var classroomId = TeacherClassroomManageViewModel.selectedClassroom.id!
    var creatorId = SignedUser.id!
    var name: String = ""
    var timeLimit: String = ""
    var passScore: Int = 0
    var beginDateTime: String = ""
    var endDateTime: String = ""
    
    func updateExamName(name: String) {
        self.name = name
    }
    
    func updateTimeLimit(hour: String, minute: String) {
        self.timeLimit = "PT\(hour)H\(minute)M"
    }
    
    func updatePassScore(score: String) {
        var scoreInput = score
        scoreInput.removeLast()
        self.passScore = Int(scoreInput)!
    }
    
    func mergeDateAndTime(date: Date, time: Date) -> String {
        var merge = date.toString()
        merge.append("T")
        merge.append(time.toString(format: "HH:mm:00"))
        
        return merge
    }
}
