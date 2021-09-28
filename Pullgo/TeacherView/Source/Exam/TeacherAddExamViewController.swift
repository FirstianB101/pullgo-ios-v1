//
//  TeacherAddExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/05.
//

import UIKit

class TeacherAddExamViewController: UIViewController {

    @IBOutlet weak var examNameField: PGTextField!
    @IBOutlet weak var hourField: PGTextField!
    @IBOutlet weak var minuteField: PGTextField!
    @IBOutlet weak var passScoreField: PGTextField!
    @IBOutlet weak var nextButton: PGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        
        if !self.checkAllFieldValid(fields: [examNameField, hourField, minuteField, passScoreField]) {
            createdExam.updateExamName(name: examNameField.text!)
            createdExam.updateTimeLimit(hour: hourField.text!, minute: minuteField.text!)
            createdExam.updatePassScore(score: passScoreField.text!)
            
            presentNextVC()
        }
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

let createdExam = CreatedExam.default

class CreatedExam {
    
    static let `default` = CreatedExam()
    var exam = Exam()
    
    func updateExamName(name: String) {
        self.exam.name = name
    }
    
    func updateTimeLimit(hour: String, minute: String) {
        self.exam.timeLimit = "PT\(hour)H\(minute)M"
    }
    
    func updatePassScore(score: String) {
        var scoreInput = score
        scoreInput.removeLast()
        self.exam.passScore = Int(scoreInput)!
    }
    
    func mergeDateAndTime(date: Date, time: Date) -> String {
        var merge = date.toString()
        merge.append("T")
        merge.append(time.toString(format: "HH:mm:00"))
        
        return merge
    }
}
