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

class TeacherCreateLessonViewController: UIViewController, Styler {
    
    let viewModel = TeacherCreateLessonViewModel()
    @IBOutlet weak var lessonNameField: UITextField!
    @IBOutlet weak var classroomSelectButton: UIButton!
    @IBOutlet weak var scheduleSelectButton: UIButton!
    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var classroomInfoLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var schedulePeriodLabel: UILabel!
    @IBOutlet weak var createLessonButton: PGButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.networkAlertDelegate = self
        setFieldUI()
        setButtonUI()
        self.setDismissKeyboardEnable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let pvc = self.presentingViewController! as! TeacherCalendarSelectViewController
        guard let date = viewModel.selectedDate else { return }
        pvc.delegate?.requestLesson(of: date) {
            pvc.reloadTableView()
        }
    }
    
    func setFieldUI() {
        setTextFieldBorderUnderline(field: lessonNameField)
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: classroomSelectButton, radius: 25)
        setViewCornerRadius(view: scheduleSelectButton, radius: 25)
        setViewCornerRadius(view: createLessonButton)
        setViewShadow(view: classroomSelectButton)
        setViewShadow(view: scheduleSelectButton)
        setViewShadow(view: createLessonButton)
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
            postLessonWithPresentAlert()
        }
    }
    
    func postLessonWithPresentAlert() {
        let alert = AlertPresentor(presentor: self)
        let cancel = alert.cancel
        let apply = UIAlertAction(title: "확인", style: .default, handler: { action in
            self.viewModel.postLesson() {
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
    func datePickerView(schedule: Schedule) {
        updateSchedule(schedule: schedule)
    }
    
    private func updateSchedule(schedule: Schedule) {
        viewModel.lessonSchedule = schedule
        setButtonColorSelected(button: scheduleSelectButton)
        setButtonLabelToSchedule(schedule: schedule)
    }
    
    private func setButtonLabelToSchedule(schedule: Schedule) {
        scheduleSelectButton.setTitle("", for: .normal)
        scheduleDateLabel.text = viewModel.getDateOfSchedule()
        schedulePeriodLabel.text = viewModel.getPeriodOfSchedule()
    }
    
    var getSelectedDate: Date {
        viewModel.selectedDate ?? Date()
    }
    
    var getSchedule: Schedule? {
        viewModel.lessonSchedule
    }
    
    private func setScheduleButtonLabelToDefault() {
        scheduleSelectButton.setTitle("수업 시간을 설정해주세요.", for: .normal)
        scheduleDateLabel.text = ""
        schedulePeriodLabel.text = ""
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
        let classroomParse = classroom.parse
        classroomNameLabel.text = classroomParse.classroomName
        classroomInfoLabel.text = "\(classroomParse.teacherName) (\(classroomParse.weekday))"
    }
    
    private func setButtonColorSelected(button: UIButton) {
        button.backgroundColor = UIColor(named: "SelectedColor")
    }
}

extension TeacherCreateLessonViewController: NetworkAlertDelegate {
    func networkFailAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.presentNetworkError()
    }
}

class TeacherCreateLessonViewModel {
    var selectedDate: Date?
    var selectedClassroom: Classroom?
    var lessonSchedule: Schedule?
    var lessonName: String = ""
    var networkAlertDelegate: NetworkAlertDelegate?
    
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
    
    func postLesson(complete: @escaping EmptyClosure) {
        let url: URL = NetworkManager.assembleURL("academy", "classroom", "lessons")
        let lesson: Lesson = Lesson(id: nil, classroomId: selectedClassroom!.id!, name: lessonName, schedule: lessonSchedule!)
        
        let fail: FailClosure = {
            self.networkAlertDelegate?.networkFailAlert()
        }
        
        NetworkManager.post(url: url, data: lesson, success: nil, fail: fail, complete: complete)
    }
}
