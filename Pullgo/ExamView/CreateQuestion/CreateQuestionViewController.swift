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
    
    
    lazy var saveButton = { () -> UIButton in
        let save = UIButton(type: .custom)
        
        save.setTitle("저장", for: .normal)
        save.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        save.addTarget(self, action: #selector(self.saveQuestions(_:)), for: .touchUpInside)
        
        return save
    }()
    
    // MARK: - Initializer + viewModel
    
    let createQuestionViewModel: CreateQuestionViewModel
    
    override init(viewModel: ExamPagableViewModel, type: ExamType) {
        guard let createQuestionViewModel = viewModel as? CreateQuestionViewModel else {
            fatalError("viewModel must be a CreateQuestionViewModel type.")
        }
        self.createQuestionViewModel = createQuestionViewModel
        super.init(viewModel: createQuestionViewModel, type: .create)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBar.topItem?.titleView = setTimeLimitField
        self.setTitleBarButtons()
        
        buildConstraints()
    }
    
    func setTitleBarButtons() {
        titleBar.topItem?.setRightBarButtonItems([addQuestion, deleteQuestion], animated: true)
    }
    
    private func buildConstraints() {
        self.view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
    
    // edit choice
    @objc
    func editChoice(_ sender: UIButton) {
        let vc = QuestionChoiceViewController(viewType: .create)
        
        self.view.alpha = 0.3
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.view.layer.cornerRadius = 25
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // save
    @objc
    func saveQuestions(_ sender: UIButton) {
        let alert = PGAlertPresentor()
        let leave = UIAlertAction(title: "나가기", style: .default) { _ in
            let topViewController = UIApplication.shared.topViewController
            topViewController?.dismiss(animated: true, completion: nil)
        }
        
        let cont = UIAlertAction(title: "계속 출제하기", style: .default, handler: nil)
        
        // save logic { _ in }
        alert.present(title: "저장 완료", context: "지금까지 만든 문제들을 모두 저장했어요.", actions: [leave, cont])
    }
}
