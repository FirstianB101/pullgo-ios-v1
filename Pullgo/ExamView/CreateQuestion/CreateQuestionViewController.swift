//
//  CreateExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CreateQuestionViewController: ExamRootViewController {
    
    let picker: UIDatePicker = { () -> UIDatePicker in
        let picker = UIDatePicker(mode: .countDownTimer)
        
        picker.locale = Locale(identifier: "ko_KR")
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    lazy var toolbar = { () -> UIToolbar in
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let space = UIBarButtonItem(systemItem: .flexibleSpace, primaryAction: nil, menu: nil)
        let okay = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.setTimeLimit(_:)))
        
        toolbar.setItems([space, okay], animated: true)
        
        return toolbar
    }()
    
    lazy var setTimeLimitField = { () -> UITextField in
        let field = UITextField()
        
        field.placeholder = "제한 시간 입력"
        field.inputAccessoryView = toolbar
        field.inputView = picker
        field.textColor = UIColor(named: "AccentColor")
        field.textAlignment = .center
        
        return field
    }()
    
    lazy var deleteQuestion = { () -> UIBarButtonItem in
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeQuestion(_:)))
    }()
    
    lazy var addQuestion = { () -> UIBarButtonItem in
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addQuestion(_:)))
    }()
    
    lazy var questionContent = { () -> UITextView in
        let textView = UITextView()
        return textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBar.topItem?.titleView = setTimeLimitField
        self.setTitleBarButtons()
        
        
        // DEBUG
        let button = UIButton(frame: CGRect(x: 40, y: 30, width: 100, height: 50))
        button.setTitle("전환", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(debugSelector), for: .touchUpInside)
        
        self.view.addSubview(button)
        // DEBUG
    }
    
    func setTitleBarButtons() {
        titleBar.topItem?.setRightBarButtonItems([addQuestion, deleteQuestion], animated: true)
    }
    
    @objc
    func debugSelector() {
        TeacherViewSwitcher.showSideMenu(self)
    }
}

extension CreateQuestionViewController {
    
    // toolbar
    @objc
    func setTimeLimit(_ sender: UIBarButtonItem) {
        let hour = self.picker.date.toString(format: "H")
        let minute = self.picker.date.toString(format: "m")
        
        self.setTimeLimitField.text = "\(hour)시간 \(minute)분"
        self.setTimeLimitField.endEditing(true)
    }
    
    // trash
    @objc
    func removeQuestion(_ sender: UIBarButtonItem) {
        
    }
    
    // add
    @objc
    func addQuestion(_ sender: UIBarButtonItem) {
        
    }
}
