//
//  ExamPager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/03.
//

import UIKit
import RxSwift

class ExamNavigator: UIView {
    
    // UI
    lazy var questionButton = { (number: Int) -> UIButton in
        let title = String(number)
        let button = UIButton(type: .custom)
        
        button.frame.size = CGSize(width: 20, height: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(self.presentQuestion(_:)), for: .touchUpInside)
        
        return button
    }
    
    var row = UIStackView()
    let disposeBag = DisposeBag()
    
    // MARK: - viewModel + Initializer
    let viewModel: ExamPagableViewModel

    init(frame: CGRect = .zero, viewModel: ExamPagableViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "TransparentAccent")
        self.tintColor = .black
        self.setViewCornerRadiusAndShadow(radius: 15)
        buildRowStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func didMoveToWindow() {
        if self.subviews.contains(row) {
            row.removeFromSuperview()
        }
        
        self.buildRowStackView()
    }
    
    private func buildRowStackView() {
        
        let colNum = 5
        let rowNum = (viewModel.questions.count / colNum) + 1
        
        row = UIStackView()
        row.axis = .vertical
        row.alignment = .leading
        row.distribution = .fillEqually
        row.spacing = 15
        
        for i in 0 ..< rowNum {
            
            let col = UIStackView()
            col.axis = .horizontal
            col.alignment = .center
            col.distribution = .fillEqually
            col.spacing = 15
            
            for j in 0 ..< colNum {
                let index = i * colNum + j
                if (index >= viewModel.questions.count) { break }
                
                let question = viewModel.questions[index]
                col.addArrangedSubview(questionButton(question.questionNumber ?? 0))
            }
            
            if !col.arrangedSubviews.isEmpty {
                row.addArrangedSubview(col)
            }
        }
        
        self.addSubview(row)
        row.snp.makeConstraints { make in
            let padding = 15
            make.leading.top.equalToSuperview().offset(padding)
            make.bottom.trailing.equalToSuperview().offset(-padding)
        }
    }
    
    @objc
    func presentQuestion(_ sender: UIButton) {
        guard let number = Int(sender.titleLabel?.text ?? "1") else { return }
        guard let topViewController = UIApplication.shared.topViewController as? ExamRootViewController else {
            fatalError("TopViewController is not an ExamRootViewController.")
        }
        
        self.popDown {
            self.removeFromSuperview()
            if self.viewModel.currentQuestion!.questionNumber == number { return }
            topViewController.presentQuestion(at: number)
        }
    }
}
