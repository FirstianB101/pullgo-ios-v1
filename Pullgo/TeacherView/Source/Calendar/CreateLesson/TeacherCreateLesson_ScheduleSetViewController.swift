//
//  TeacherCreateLesson_DateSetViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/18.
//

import UIKit

class TeacherCreateLesson_ScheduleSetViewController: UIViewController, Styler {

    let viewModel = TeacherCreateLesson_ScheduleSetViewModel()
    var selectDateDelegate: TeacherCreateLessonDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var beginTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDatePickerLimit()
        setDatePickerSelectedDate()
        setTimePickerLimit()
        setButtonUI()
        loadScheduleIfNeeded()
    }
    
    func setDatePickerLimit() {
        datePicker.minimumDate = Date()
    }
    
    func setDatePickerSelectedDate() {
        let selectedDate = selectDateDelegate!.getSelectedDate
        datePicker.date = selectedDate >= Date() ? selectedDate : Date()
        
        viewModel.setDate(date: datePicker.date)
    }
    
    func setTimePickerLimit() {
        if datePicker.date.isToday {
            beginTimePicker.minimumDate = Date()
            endTimePicker.minimumDate = Date()
        }
        endTimePicker.date = Date(timeInterval: 2 * 60 * 60, since: Date())
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: selectButton)
        setViewShadow(view: selectButton)
        selectButton.setTitle("설정 완료", for: .normal)
        selectButton.backgroundColor = .lightGray
    }
    
    func loadScheduleIfNeeded() {
        guard let schedule = selectDateDelegate?.getSchedule else { return }
        let dateFormatter = DateFormatter()
        viewModel.schedule = schedule
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        datePicker.date = dateFormatter.date(from: schedule.date)!
        
        dateFormatter.dateFormat = "HH:mm:ss"
        beginTimePicker.date = dateFormatter.date(from: schedule.beginTime)!
        endTimePicker.date = dateFormatter.date(from: schedule.endTime)!
        updateButtonState()
    }
    
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        viewModel.setDate(date: sender.date)
        setTimePickerLimit()
    }
    
    @IBAction func beginTimeSelected(_ sender: UIDatePicker) {
        viewModel.setBeginTime(time: sender.date.toString(format: "HH:mm:ss"))
        endTimePicker.minimumDate = beginTimePicker.date
        updateButtonState()
    }
    
    @IBAction func endTimeSelected(_ sender: UIDatePicker) {
        viewModel.setEndTime(time: sender.date.toString(format: "HH:mm:ss"))
        updateButtonState()
    }
    
    func updateButtonState() {
        if viewModel.isAllSelected() {
            selectButton.backgroundColor = UIColor(named: "AccentColor")
        }
    }
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        let animator = AnimationPresentor()
        
        if !viewModel.isBeginTimeSelected() {
            animator.vibrate(view: beginTimePicker)
            return
        } else if !viewModel.isEndTimeSelected() {
            animator.vibrate(view: endTimePicker)
            return
        } else if viewModel.schedule.beginTime == viewModel.schedule.endTime {
            animator.vibrate(view: beginTimePicker)
            animator.vibrate(view: endTimePicker)
            return
        }
        
        self.selectDateDelegate?.updateSchedule(schedule: viewModel.schedule)
        self.selectDateDelegate?.updateScheduleButtonLabel()
        self.navigationController?.popViewController(animated: true)
    }
}

class TeacherCreateLesson_ScheduleSetViewModel {
    var schedule: Schedule = Schedule(date: "", beginTime: "", endTime: "")
    
    func setDate(date: Date) {
        schedule.date = date.toString()
    }
    
    func setBeginTime(time: String) {
        schedule.beginTime = time
    }
    
    func setEndTime(time: String) {
        schedule.endTime = time
    }
    
    func isAllSelected() -> Bool {
        return isBeginTimeSelected() && isEndTimeSelected()
    }
    
    func isBeginTimeSelected() -> Bool {
        return !schedule.beginTime.isEmpty
    }
    
    func isEndTimeSelected() -> Bool {
        return !schedule.endTime.isEmpty
    }
}
