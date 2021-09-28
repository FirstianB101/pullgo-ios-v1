//
//  DatePickerViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/03.
//

import UIKit
import SnapKit

/*
 - select mode
    - date, date and time, time
 */

public enum DatePickerViewMode: Int {
    case dateAndTimePeriod = 0
    case dateWithTimeLimit
}

@objc protocol DatePickerViewDelegate {
    @objc optional func datePickerView(_ sender: PGSelectButton?, schedule: Schedule)
    @objc optional func datePickerView(_ sender: PGSelectButton?, date: Date, time: Date)
}

/// Should push in Navigation Controller
/// When call this class, should set title for navigation bar
class DatePickerViewController: UIViewController {
    
    // mode dateWithTimeLimit ->
    // use beginTimeField by timeLimit
    @IBOutlet weak var dateField: PGTextField!
    @IBOutlet weak var beginTimeField: PGTextField!
    @IBOutlet weak var endTimeField: PGTextField!
    
    @IBOutlet weak var mutableStackView: UIStackView!
    @IBOutlet weak var mutableLabel: UILabel!
    
    var datePickerMode: DatePickerViewMode = .dateAndTimePeriod
    let viewModel = DatePickerViewModel()
    
    var delegate: DatePickerViewDelegate?
    var sender: PGSelectButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldToolbarDelegate()
        setUIByDatePickerViewMode()
        setFieldToDatePicker()
        self.setKeyboardDismissWatcher()
    }
    
    private func setTextFieldToolbarDelegate() {
        dateField.toolbarDelegate = self
        beginTimeField.toolbarDelegate = self
        endTimeField.toolbarDelegate = self
    }
    
    private func setUIByDatePickerViewMode() {
        if datePickerMode == .dateAndTimePeriod {
            setUIDateAndTimePeriod()
        } else if datePickerMode == .dateWithTimeLimit {
            setUIDateWithTimeLimit()
        }
    }
    
    private func setFieldToDatePicker() {
        let datePicker = UIDatePicker(mode: .date)
        let timePicker = UIDatePicker(mode: .time)
        
        datePicker.minimumDate = Date()
        dateField.useTextFieldByDatePicker(picker: datePicker)
        beginTimeField.useTextFieldByDatePicker(picker: timePicker)
        endTimeField.useTextFieldByDatePicker(picker: timePicker)
    }
    
    private func setUIDateAndTimePeriod() {
        mutableLabel.text = "시작 시간"
        mutableStackView.isHidden = false
    }
    
    private func setUIDateWithTimeLimit() {
        mutableLabel.text = "시간 설정"
        mutableStackView.isHidden = true
    }
    
    @IBAction func selectComplete(_ sender: PGButton) {
        if !checkEmptyInputs() { return }
        guard let date = viewModel.date, let beginTime = viewModel.beginTime else { return }
        
        if datePickerMode == .dateAndTimePeriod {
            if !checkTimeValid() {
                let alert = PGAlertPresentor(presentor: self)
                alert.present(title: "경고", context: "종료 시간이 시작 시간보다 빠릅니다.") { _ in
                    self.beginTimeField.becomeFirstResponder()
                }
            }
            guard let schedule = viewModel.convertSchedule() else { return }
            delegate?.datePickerView?(self.sender, schedule: schedule)
        }
        else if datePickerMode == .dateWithTimeLimit {
            delegate?.datePickerView?(self.sender, date: date, time: beginTime)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkTimeValid() -> Bool {
        if self.datePickerMode == .dateAndTimePeriod {
            return checkTimeValid_dateAndTimePeriod()
        }
        return true
    }
    
    private func checkTimeValid_dateAndTimePeriod() -> Bool {
        return viewModel.isValidTimeInterval()
    }
    
    private func checkEmptyInputs() -> Bool {
        return checkIsEmpty(fields: dateField, beginTimeField, endTimeField)
    }
    
    private func checkIsEmpty(fields: PGTextField...) -> Bool {
        for field in fields {
            if self.datePickerMode == .dateWithTimeLimit && field == endTimeField { continue }
            
            guard let text = field.text else {
                field.vibrate()
                return false
            }
            if text.isEmpty {
                field.vibrate()
                return false
            }
        }
        
        return true
    }
}

extension DatePickerViewController: PGDatePickerDelegate {
    func datePicker(_ inputView: PGTextField, selected: Date) {
        if inputView == dateField {
            inputView.text = selected.toString(format: "YYYY / MM / dd")
            viewModel.setDate(date: selected)
        } else {
            inputView.text = selected.toString(format: "HH : mm")
            
            if inputView == beginTimeField {
                viewModel.setBeginTime(time: selected)
            } else if inputView == endTimeField {
                viewModel.setEndTime(time: selected)
            }
        }
    }
}

class DatePickerViewModel {
    var date: Date?
    var beginTime: Date?
    var endTime: Date?
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    public func setBeginTime(time: Date) {
        self.beginTime = time
    }
    
    public func setEndTime(time: Date) {
        self.endTime = time
    }
    
    public func isValidTimeInterval() -> Bool {
        guard let beginTime = self.beginTime, let endTime = self.endTime else { return false }
        return beginTime < endTime
    }
    
    public func convertSchedule() -> Schedule? {
        guard let date = self.date?.toString(),
              let beginTime = self.beginTime?.toString(format: "HH:mm:ss"),
              let endTime = self.endTime?.toString(format: "HH:mm:ss") else { return nil }
        
        return Schedule(date: date, beginTime: beginTime, endTime: endTime)
    }
}

extension UIDatePicker {
    convenience init(mode: UIDatePicker.Mode) {
        self.init()
        
        self.datePickerMode = mode
        self.locale = .current
    }
}
