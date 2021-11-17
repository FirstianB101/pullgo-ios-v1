//
//  TakeExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/26.
//

import UIKit

class TakeExamViewController: ExamRootViewController {
    
    let takeExamViewModel: TakeExamViewModel
    
    // MARK: - UI
    lazy var doneButton = { () -> UIBarButtonItem in
        let done = UIBarButtonItem(title: "응시 완료", style: .done, target: self, action: #selector(self.doneButtonClicked(_:)))
        
        return done
    }()
    
    lazy var timeLimitLabel = { () -> UILabel in
        let label = UILabel()
        
        label.text = self.takeExamViewModel.selectedExam.timeLimit.toTimeLimit(hourSuffix: "시간", minuteSuffix: "분")
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        
        return label
    }()
    
    // MARK: - Initializer
    override init(viewModel: ExamPagableViewModel, type: ExamType) {
        guard let takeExamViewModel = viewModel as? TakeExamViewModel else {
            fatalError("viewModel must be a TakeExamViewModel type.")
        }
        self.takeExamViewModel = takeExamViewModel
        super.init(viewModel: takeExamViewModel, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleBar()
    }
    
    func setTitleBar() {
        self.titleBar.topItem?.setRightBarButton(self.doneButton, animated: true)
        self.titleBar.topItem?.titleView = timeLimitLabel
    }

    // MARK: - objc Method
    @objc
    func doneButtonClicked(_ sender: UIBarButtonItem) {
        let alert = PGAlertPresentor()
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let okay = UIAlertAction(title: "나가기", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.present(title: "알림", context: """
                      응시를 완료하면 다시 들어올 수 없습니다.
                      응시를 완료하고 나갈까요?
                      """,
                      actions: [cancel, okay])
    }
    
    @objc func selectChoice(_ sender: UIButton) {
        let vc = ChoiceViewController(examType: self.examType, viewModel: takeExamViewModel)
        
        self.view.gettingDark()
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.view.layer.cornerRadius = 25
        
        self.present(vc, animated: true, completion: nil)
    }
}
