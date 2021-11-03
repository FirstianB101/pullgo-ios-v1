//
//  ExamPager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/03.
//

import UIKit

class ExamNavigator: UIView {
    
    // UI
    lazy var questionButton = { (number: Int) -> UIButton in
        let title = String(number)
        let button = UIButton(type: .custom)
        
        button.frame.size = CGSize(width: 20, height: 20)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(self.presentQuestion(_:)), for: .touchUpInside)
        
        return button
    }
    
    let row = UIStackView()
    
    // Logic
    let viewModel: ExamPagableViewModel

    init(frame: CGRect = .zero, viewModel: ExamPagableViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        func buildRowStackView() {
            
            let colNum = 5
            let rowNum = (viewModel.questions.count / colNum) + 1
            
            row.axis = .vertical
            row.alignment = .leading
            row.distribution = .fillEqually
            row.spacing = 10
            
            for i in 0 ..< rowNum {
                
                let col = UIStackView()
                col.axis = .horizontal
                col.alignment = .center
                col.distribution = .fillEqually
                
                for j in 0 ..< colNum {
                    let index = i * colNum + j
                    if (index >= viewModel.questions.count) { break }
                    
                    let question = viewModel.questions[index]
                    col.addArrangedSubview(questionButton(question.questionNumber ?? 0))
                }
                
                row.addArrangedSubview(col)
            }
            
            self.addSubview(row)
            row.snp.makeConstraints { make in
                let padding = 10
                make.leading.top.equalToSuperview().offset(padding)
                make.bottom.trailing.equalToSuperview().offset(-padding)
            }
        }
        
        self.backgroundColor = UIColor(named: "TransparentAccent")
        self.tintColor = .black
        self.setViewCornerRadiusAndShadow(radius: 15)
        buildRowStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc
    func presentQuestion(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        print(number)
        // number으로 뷰 표시해주기
        
        self.popDown {
            self.removeFromSuperview()
        }
    }
}
