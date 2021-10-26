//
//  TeacherExamEditViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/23.
//

import UIKit
import XLPagerTabStrip

class TeacherExamEditViewController: UIViewController, IndicatorInfoProvider {
    
    var viewModel: TeacherManageExamViewModel
    
    @IBOutlet weak var examNameField: PGTextField!
    @IBOutlet weak var passScoreField: PGTextField!
    @IBOutlet weak var beginTimeField: PGTextField!
    @IBOutlet weak var endTimeField: PGTextField!
    @IBOutlet weak var timeLimitField: PGTextField!
    
    let dateAndTimePicker = UIDatePicker(mode: .dateAndTime)
    let timePicker = UIDatePicker(mode: .time)
    
    init?(coder: NSCoder, viewModel: TeacherManageExamViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("TeacherExamEditViewController: viewModel is nil.")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수정")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setKeyboardDismissWatcher()
        setDefaultValue()
        setDateTimeKeyboard()
    }
    
    private func setDefaultValue() {
        examNameField.text = viewModel.name
        passScoreField.text = String(viewModel.passScore)
        beginTimeField.text = viewModel.beginDateTime.toString(format: "YYYY/MM/dd HH:mm")
        endTimeField.text = viewModel.endDateTime.toString(format: "YYYY/MM/dd HH:mm")
        timeLimitField.text = viewModel.timeLimit.toString(format: "H시간 m분")
    }
    
    private func setDateTimeKeyboard() {
        beginTimeField.useTextFieldByDatePicker(picker: dateAndTimePicker)
        endTimeField.useTextFieldByDatePicker(picker: dateAndTimePicker)
        timeLimitField.useTextFieldByDatePicker(picker: timePicker)
    }
}
