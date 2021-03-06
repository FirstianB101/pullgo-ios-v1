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
}

class TeacherCreateLessonViewController: UIViewController {
    
    let viewModel = TeacherCreateLessonViewModel()
    @IBOutlet weak var lessonNameField: PGTextField!
    @IBOutlet weak var classroomSelectButton: UIButton!
    @IBOutlet weak var scheduleSelectButton: PGSelectButton!
    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var classroomInfoLabel: UILabel!
    @IBOutlet weak var createLessonButton: PGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonUI()
        self.setKeyboardDismissWatcher()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let pvc = self.presentingViewController! as! TeacherCalendarSelectViewController
        
        pvc.reloadTableView()
    }
    
    func setButtonUI() {
        classroomSelectButton.setViewCornerRadiusAndShadow(radius: 15)
        setButtonLabelDefault()
    }
    
    private func setButtonLabelDefault() {
        setSelectButtonLabelToDefault()
        setScheduleButtonLabelToDefault()
    }
    
    private func setSelectButtonLabelToDefault() {
        classroomSelectButton.setTitle("반을 선택해주세요.", for: .normal)
        classroomNameLabel.text = ""
        classroomInfoLabel.text = ""
    }
    
    private func setScheduleButtonLabelToDefault() {
        scheduleSelectButton.setState(for: .deselect)
        scheduleSelectButton.setTitle("수업 시간을 설정해주세요.", for: .normal)
    }
    
    @IBAction func selectClassroomButtonClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TeacherCreateLesson_SelectClassroomViewController") as! TeacherCreateLesson_SelectClassroomViewController
        vc.selectClassroomDelegate = self
        vc.navigationItem.title = "반 선택"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectScheduleButtonClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "datePickerView") as! DatePickerViewController
        vc.navigationItem.title = "수업 시간 설정"
        vc.datePickerMode = .dateAndTimePeriod
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createLessonButtonClicked(_ sender: UIButton) {
        viewModel.lessonName = lessonNameField.text!
        if lessonNameField.text!.isEmpty {
            lessonNameField.vibrate()
        } else if viewModel.selectedClassroom == nil {
            classroomSelectButton.vibrate()
        } else if viewModel.lessonSchedule == nil {
            scheduleSelectButton.vibrate()
        } else {
            createLesson()
        }
    }
    
    func createLesson() {
        let alert = PGAlertPresentor(presentor: self)
        let cancel = alert.cancel
        let apply = UIAlertAction(title: "확인", style: .default, handler: { action in
            self.viewModel.createLesson() {
                alert.present(title: "알림", context: "수업이 생성되었습니다!") { _ in
                    self.dismiss(animated: true)
                }
            }
        })
        alert.present(title: viewModel.lessonName,
                      context: "반: \(viewModel.selectedClassroom!.parse.classroomName)\n일시: \(viewModel.getDateOfSchedule())\n시간: \(viewModel.getPeriodOfSchedule())\n\n위 정보로 수업을 생성합니다.",
                      actions: [cancel, apply])
        
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TeacherCreateLessonViewController: DatePickerViewDelegate, TeacherCreateLessonDelegate {
    func datePickerView(_ sender: PGSelectButton?, schedule: Schedule) {
        updateSchedule(schedule: schedule)
    }
    
    private func updateSchedule(schedule: Schedule) {
        viewModel.lessonSchedule = schedule
        setButtonColorSelected(button: scheduleSelectButton)
        setButtonLabelToSchedule(schedule: schedule)
    }
    
    private func setButtonLabelToSchedule(schedule: Schedule) {
        scheduleSelectButton.setState(for: .selected)
        let date = viewModel.getDateOfSchedule()
        let period = viewModel.getPeriodOfSchedule()
        
        scheduleSelectButton.setSelectedTitle(date)
        scheduleSelectButton.setSelectedSubtitle(period)
    }
    
    var getSelectedDate: Date {
        viewModel.selectedDate ?? Date()
    }
    
    var getSchedule: Schedule? {
        viewModel.lessonSchedule
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
    
    private func setButtonLabelToClassroomInfo(classroom: Classroom) {
        classroomSelectButton.setTitle("", for: .normal)
        let classroomParse = classroom
        classroomNameLabel.text = classroom.parse.classroomName
        classroomInfoLabel.text = "\(classroom.creator.account.fullName) (\(classroom.parse.weekday))"
    }
    
    private func setButtonColorSelected(button: UIButton) {
        button.backgroundColor = UIColor(named: "SelectedColor")
    }
}

class TeacherCreateLessonViewModel {
    var selectedDate: Date?
    var selectedClassroom: Classroom?
    var lessonSchedule: Schedule?
    var lessonName: String = ""
    
    func getDateOfSchedule() -> String {
        guard let schedule = lessonSchedule else { return "" }
        let dateSeparated = schedule.date.split(separator: "-")
        
        return "\(dateSeparated[0])년 \(dateSeparated[1])월 \(dateSeparated[2])일"
    }
    
    func getPeriodOfSchedule() -> String {
        guard let schedule = lessonSchedule else { return "" }
        let beginTimeSeparated = splitTime(time: schedule.beginTime)
        let endTimeSeparated = splitTime(time: schedule.endTime)
        
        return "\(beginTimeSeparated[0]):\(beginTimeSeparated[1]) ~ \(endTimeSeparated[0]):\(endTimeSeparated[1])"
    }
    
    private func splitTime(time: String) -> [String.SubSequence] {
        return time.split(separator: ":")
    }
    
    func createLesson(complete: @escaping (() -> Void)) {
        let lesson = Lesson()
        
        lesson.name = self.lessonName
        lesson.classroomId = self.selectedClassroom!.id
        lesson.schedule = self.lessonSchedule
        
        lesson.post(success: { _ in complete() })
    }
}
