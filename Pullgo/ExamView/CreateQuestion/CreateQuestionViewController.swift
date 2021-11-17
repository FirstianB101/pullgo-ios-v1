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
    
    lazy var exitButton = { () -> UIBarButtonItem in
        let exit = UIBarButtonItem(title: "나가기", style: .plain, target: self, action: #selector(self.exitExam(_:)))
        
        return exit
    }()
    
    
    lazy var deleteQuestion = { () -> UIBarButtonItem in
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeQuestion(_:)))
    }()
    
    lazy var addQuestion = { () -> UIBarButtonItem in
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addQuestion(_:)))
    }()
    
    lazy var timeLimit = { () -> UILabel in
        let label = UILabel()
        
        label.text = self.createQuestionViewModel.selectedExam.timeLimit.toTimeLimit()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemOrange
        
        return label
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
        super.init(viewModel: createQuestionViewModel, type: type)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTimeLimitLabel()
        self.setTitleBarButtons()
        buildConstraints()
    }
    
    private func setTimeLimitLabel() {
        titleBar.topItem?.titleView = timeLimit
    }
    
    func setTitleBarButtons() {
        titleBar.topItem?.setRightBarButtonItems([addQuestion, deleteQuestion], animated: true)
        titleBar.topItem?.leftBarButtonItems?.append(.fixedSpace(20))
        titleBar.topItem?.leftBarButtonItems?.append(self.exitButton)
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
    
    // trash
    @objc
    func removeQuestion(_ sender: UIBarButtonItem) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // 문제 삭제
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.present(title: "알림", context: "해당 문제를 삭제할까요?", actions: [cancel, okay])
    }
    
    // add
    @objc
    func addQuestion(_ sender: UIBarButtonItem) {
        createQuestionViewModel.createQuestion()
        guard let presentQuestionNumber = createQuestionViewModel.currentQuestion?.questionNumber else {
            print("presentQuestionNumber is nil.")
            return
        }
        
        self.presentQuestion(at: presentQuestionNumber)
    }
    
    // edit choice
    @objc
    func editChoice(_ sender: UIButton) {        
        let vc = ChoiceViewController(examType: self.examType, viewModel: createQuestionViewModel)
       
        self.view.gettingDark()
        
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
        
        createQuestionViewModel.saveQuestions {
            alert.present(title: "저장 완료", context: "지금까지 만든 문제들을 모두 저장했어요.", actions: [leave, cont])
        }
        
    }
    
    // exit
    @objc
    private func exitExam(_ sender: UIBarButtonItem) {
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "나가기", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.present(title: "나가기",
                      context: """
                      시험 문제 수정을 종료할까요?
                      변경 사항은 저장되지 않습니다.
                      """,
                      actions: [cancel, okay])
    }
}
