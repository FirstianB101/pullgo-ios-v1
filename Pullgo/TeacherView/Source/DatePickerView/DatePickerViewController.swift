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
    case dateAndTime = 0
    case dateWithTimeLimit
}

@objc protocol DatePickerViewDelegate {
    @objc optional func datePickerView(date: Date, beginTime: Date, endTime: Date)
    @objc optional func datePickerView(date: Date, timeLimit: Date)
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
    
    var datePickerMode: DatePickerViewMode = .dateAndTime
    let viewModel = DatePickerViewModel()
    var delegate: DatePickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldToolbarDelegate()
        setUIByDatePickerViewMode()
        setFieldToDatePicker()
        setKeyboardWatcher()
    }
    
    private func setTextFieldToolbarDelegate() {
        dateField.toolbarDelegate = self
        beginTimeField.toolbarDelegate = self
        endTimeField.toolbarDelegate = self
    }
    
    private func setUIByDatePickerViewMode() {
        if datePickerMode == .dateAndTime {
            setUIDateAndTime()
        } else if datePickerMode == .dateWithTimeLimit {
            setUIDateWithTimeLimit()
        }
    }
    
    private func setFieldToDatePicker() {
        let datePicker = UIDatePicker(mode: .date)
        let timePicker = UIDatePicker(mode: .time)
        
        dateField.useTextFieldByDatePicker(picker: datePicker)
        beginTimeField.useTextFieldByDatePicker(picker: timePicker)
        endTimeField.useTextFieldByDatePicker(picker: timePicker)
    }
    
    private func setUIDateAndTime() {
        mutableLabel.text = "시작 시간"
        mutableStackView.isHidden = false
    }
    
    private func setUIDateWithTimeLimit() {
        mutableLabel.text = "시간 설정"
        mutableStackView.isHidden = true
    }
    
    @IBAction func selectComplete(_ sender: PGButton) {
        guard let date = viewModel.date, let beginTime = viewModel.beginTime else { return }
        
        if datePickerMode == .dateAndTime {
            guard let endTime = viewModel.endTime else { return }
            delegate?.datePickerView?(date: date, beginTime: beginTime, endTime: endTime)
        }
        else if datePickerMode == .dateWithTimeLimit {
            delegate?.datePickerView?(date: date, timeLimit: beginTime)
        }
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
        self.locale = Locale(identifier: "ko_KR")
    }
}
