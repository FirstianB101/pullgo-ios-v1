//
//  TeacherCreateLessonViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/15.
//

import UIKit

protocol TeacherCreateLessonDelegate: AnyObject {
    func updateSelectedClassroomButtonLabel()
    func updateSelectedClassroom(selected: Classroom)
    func updateSchedule(schedule: Schedule)
    func updateScheduleButtonLabel()
}

class TeacherCreateLessonViewController: UIViewController {
    
    let viewModel = TeacherCreateLessonViewModel()
    @IBOutlet weak var classroomSelectButton: UIButton!
    @IBOutlet weak var scheduleSelectButton: UIButton!
    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var classroomInfoLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var schedulePeriodLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.networkAlertDelegate = self
        setButtonUI()
    }
    
    func setButtonUI() {
        classroomSelectButton.layer.cornerRadius = 25
        scheduleSelectButton.layer.cornerRadius = 25
        setButtonLabelDefault()
    }
    
    private func setButtonLabelDefault() {
        setSelectButtonLabelToDefault()
        setScheduleButtonLabelToDefault()
    }
    
    @IBAction func selectClassroomButtonClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherCreateLesson_SelectClassroomViewController") as! TeacherCreateLesson_SelectClassroomViewController
        vc.selectClassroomDelegate = self
        vc.navigationItem.title = "반 선택"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectScheduleButtonClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherCreateLesson_ScheduleSetViewController") as! TeacherCreateLesson_ScheduleSetViewController
        vc.selectDateDelegate = self
        vc.navigationItem.title = "수업 시간 설정"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TeacherCreateLessonViewController: TeacherCreateLessonDelegate {
    func updateSchedule(schedule: Schedule) {
        viewModel.lessonSchedule = schedule
        setButtonColorSelected(button: scheduleSelectButton)
    }
    
    func updateScheduleButtonLabel() {
        guard let schedule = viewModel.lessonSchedule else {
            setScheduleButtonLabelToDefault()
            return
        }
        setButtonLabelToSchedule(schedule: schedule)
    }
    
    private func setScheduleButtonLabelToDefault() {
        scheduleSelectButton.setTitle("수업 시간을 설정해주세요.", for: .normal)
        scheduleDateLabel.text = ""
        schedulePeriodLabel.text = ""
    }
    
    private func setButtonLabelToSchedule(schedule: Schedule) {
        scheduleSelectButton.setTitle("", for: .normal)
        scheduleDateLabel.text = viewModel.getDateOfSchedule()
    }
    
    func updateSelectedClassroom(selected: Classroom) {
        viewModel.selectedClassroom = selected
        setButtonColorSelected(button: classroomSelectButton)
    }
    
    func updateSelectedClassroomButtonLabel() {
        guard let selectedClassroom = viewModel.selectedClassroom else {
            setSelectButtonLabelToDefault()
            return
        }
        setButtonLabelToClassroomInfo(classroom: selectedClassroom)
    }
    
    private func setSelectButtonLabelToDefault() {
        classroomSelectButton.setTitle("반을 선택해주세요.", for: .normal)
        classroomNameLabel.text = ""
        classroomInfoLabel.text = ""
    }
    
    private func setButtonLabelToClassroomInfo(classroom: Classroom) {
        classroomSelectButton.setTitle("", for: .normal)
        let classroomParse = classroom.parseClassroomName()
        classroomNameLabel.text = classroomParse.classroomName
        classroomInfoLabel.text = "\(classroomParse.teacherName) (\(classroomParse.weekday))"
    }
    
    private func setButtonColorSelected(button: UIButton) {
        button.backgroundColor = UIColor(named: "LightAccent")
    }
}

extension TeacherCreateLessonViewController: NetworkAlertDelegate {
    func networkFailAlert() {
        let alert = AlertPresentor(view: self)
        alert.presentNetworkError()
    }
}

class TeacherCreateLessonViewModel {
    var selectedClassroom: Classroom?
    var lessonSchedule: Schedule?
    var networkAlertDelegate: NetworkAlertDelegate?
    
    func getDateOfSchedule() -> String {
        guard let schedule = lessonSchedule else { return "" }
        let dateSeparated = schedule.date.split(separator: "-")
        
        return "\(dateSeparated[0])년 \(dateSeparated[1])월 \(dateSeparated[2])일"
    }
}
