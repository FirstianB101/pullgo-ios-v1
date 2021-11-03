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
        field.font = UIFont.boldSystemFont(ofSize: 18)
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
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.2
        textView.textContainer.lineFragmentPadding = 10
        textView.setViewCornerRadius(radius: 15)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = self
        
        return textView
    }()
    
    lazy var questionLength = { () -> UILabel in
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "0/200자"
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var questionContentStack = { () -> UIStackView in
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        
        stack.addArrangedSubview(self.questionContent)
        stack.addArrangedSubview(self.questionLength)
        
        return stack
    }()
    
    lazy var addImageButton = { () -> UIButton in
        let button = UIButton()
        
    }
    
    lazy var tabBarPager = { () -> ExamTabBarPager in
        let pager = ExamTabBarPager(viewModel: self.createQuestionViewModel, type: .withSave)
        
        return pager
    }()
    
    // MARK: - Initializer + viewModel
    
    let createQuestionViewModel: CreateQuestionViewModel
    
    override init(viewModel: ExamPagableViewModel) {
        guard let createQuestionViewModel = viewModel as? CreateQuestionViewModel else {
            fatalError("viewModel must be a CreateQuestionViewModel type.")
        }
        self.createQuestionViewModel = createQuestionViewModel
        super.init(viewModel: createQuestionViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBar.topItem?.titleView = setTimeLimitField
        self.setTitleBarButtons()
        self.setTabBarPager()
        
        buildConstraints()
    }
    
    func setTitleBarButtons() {
        titleBar.topItem?.setRightBarButtonItems([addQuestion, deleteQuestion], animated: true)
    }
    
    func setTabBarPager() {
        self.view.addSubview(tabBarPager)
        
        tabBarPager.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
    
    func buildConstraints() {
        self.view.addSubview(questionContentStack)
        questionContentStack.snp.makeConstraints { make in
            make.top.equalTo(self.titleBar.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.tabBarPager.snp.top).offset(-30)
        }
    }
}

extension CreateQuestionViewController {
    
    // toolbar
    @objc
    func setTimeLimit(_ sender: UIBarButtonItem) {
        var hour = self.picker.date.toString(format: "H")
        var minute = self.picker.date.toString(format: "m")
        
        hour = hour == "0" ? "" : hour + "시간"
        minute = minute == "0" ? "" : minute + "분"
        if hour == "" && minute == "" {
            self.setTimeLimitField.endEditing(true)
            return
        }
        
        self.setTimeLimitField.text = "\(hour) \(minute)"
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

// TextView Placeholder
extension CreateQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "문제를 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        
        if count > createQuestionViewModel.maxContentLength {
            textView.text.removeLast()
            questionLength.vibrate()
            return
        }
        
        questionLength.text = "\(count)/\(createQuestionViewModel.maxContentLength)자"
    }
}
