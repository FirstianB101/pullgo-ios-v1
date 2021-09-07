////
////  TeacherCreateLesson_DateSetViewController.swift
////  Pullgo
////
////  Created by 김세영 on 2021/07/18.
////
//
//import UIKit
//
//class TeacherCreateLesson_ScheduleSetViewController: UIViewController, PGDatePickerDelegate {
//
//    let viewModel = TeacherCreateLesson_ScheduleSetViewModel()
//    let datePicker = UIDatePicker()
//    let timePicker = UIDatePicker()
//    var selectDateDelegate: TeacherCreateLessonDelegate?
//    @IBOutlet weak var selectButton: PGButton!
//    @IBOutlet weak var lessonDateField: PGTextField!
//    @IBOutlet weak var lessonStartTimeField: PGTextField!
//    @IBOutlet weak var lessonEndTimeField: PGTextField!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setPickerInfo()
//        setDatePickerLimit()
//        setDatePickerSelectedDate()
//        setKeyboardWatcher()
//    }
//    
//    func setPickerInfo() {
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.locale = Locale(identifier: "ko_KR")
//        timePicker.preferredDatePickerStyle = .wheels
//        timePicker.locale = Locale(identifier: "ko_KR")
//        
//        setDatePickerView()
//        setTimePickerView()
//    }
//    
//    func setDatePickerLimit() {
//        datePicker.minimumDate = Date()
//    }
//    
//    func setDatePickerSelectedDate() {
//        let selectedDate = selectDateDelegate!.getSelectedDate
//        datePicker.date = selectedDate >= Date() ? selectedDate : Date()
//        
//        viewModel.setDate(date: datePicker.date)
//    }
//    
//    func setDatePickerView() {
//        datePicker.datePickerMode = .date
//        lessonDateField.useTextFieldByDatePicker(picker: datePicker)
//        lessonDateField.toolbarDelegate = self
//    }
//    
//    func setTimePickerView() {
//        timePicker.datePickerMode = .time
//        lessonStartTimeField.useTextFieldByDatePicker(picker: timePicker)
//        lessonStartTimeField.toolbarDelegate = self
//        lessonEndTimeField.useTextFieldByDatePicker(picker: timePicker)
//        lessonEndTimeField.toolbarDelegate = self
//    }
//    
//    @IBAction func selectButtonClicked(_ sender: UIButton) {
//        if !viewModel.isBeginTimeSelected() {
//            lessonDateField.vibrate()
//            return
//        } else if !viewModel.isEndTimeSelected() {
//            lessonStartTimeField.vibrate()
//            return
//        } else if viewModel.schedule.beginTime == viewModel.schedule.endTime {
//            lessonStartTimeField.vibrate()
//            lessonEndTimeField.vibrate()
//            return
//        }
//        
//        self.selectDateDelegate?.updateSchedule(schedule: viewModel.schedule)
//        self.selectDateDelegate?.updateScheduleButtonLabel()
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func datePicker(_ inputView: PGTextField, selected: Date) {
//        var format: String
//        
//        if inputView == lessonDateField {
//            format = "YYYY / MM / dd"
//        } else {
//            format = "HH : mm"
//        }
//        
//        inputView.text = selected.toString(format: format + "  ")
//    }
//}
//
//class TeacherCreateLesson_ScheduleSetViewModel {
//    var schedule: Schedule = Schedule(date: "", beginTime: "", endTime: "")
//    
//    func setDate(date: Date) {
//        schedule.date = date.toString()
//    }
//    
//    func setBeginTime(time: String) {
//        schedule.beginTime = time
//    }
//    
//    func setEndTime(time: String) {
//        schedule.endTime = time
//    }
//    
//    func isAllSelected() -> Bool {
//        return isBeginTimeSelected() && isEndTimeSelected()
//    }
//    
//    func isBeginTimeSelected() -> Bool {
//        return !schedule.beginTime.isEmpty
//    }
//    
//    func isEndTimeSelected() -> Bool {
//        return !schedule.endTime.isEmpty
//    }
//}
