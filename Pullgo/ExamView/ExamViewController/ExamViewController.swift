//
//  ExamViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/01.
//

import UIKit
import SnapKit

protocol ExamPagableViewModel {
    var currentQuestion: Question { get set }
    var questions: [Question] { get set }
    var selectedExam: Exam { get }
}

class ExamRootViewController: UIViewController {
    
    let viewModel: ExamPagableViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ExamPagableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var examPagerButton = { () -> UIBarButtonItem in
        let buttonEdge: CGFloat = 30
        
        let customView = UIButton()
        customView.frame.size = CGSize(width: buttonEdge, height: buttonEdge)
        customView.layer.cornerRadius = buttonEdge / 2
        customView.backgroundColor = UIColor(named: "LightAccent")
        customView.setTitleColor(.black, for: .normal)
        customView.setTitle(String(self.viewModel.currentQuestion.questionNumber ?? 0), for: .normal)
        customView.addTarget(self, action: #selector(self.presentQuestionList(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: customView)
    }()
    
    lazy var titleBar = { () -> UINavigationBar in
        let bar = UINavigationBar()
        
        bar.barTintColor = .white
        bar.setItems([UINavigationItem()], animated: true)
        bar.topItem?.setLeftBarButton(self.examPagerButton, animated: false)
        
        return bar
    }()
    
    @objc
    private func presentQuestionList(_ sender: UIButton) {
        print("list")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
