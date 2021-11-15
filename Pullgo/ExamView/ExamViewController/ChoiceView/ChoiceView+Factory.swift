//
//  ChoiceViewFactory.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/13.
//

import UIKit
import SnapKit

class ChoiceViewFactory {
    
    public static func getChoiceView(of type: ExamType, viewModel: ExamViewModel) -> ChoiceView {
        
        switch type {
            case .create:
                return CreateQuestionChoiceView(examType: type, viewModel: viewModel)
            case .history:
                return ExamHistoryChoiceView(examType: type, viewModel: viewModel)
            case .take:
                return TakeExamChoiceView(examType: type, viewModel: viewModel)
        }
    }
}

class ChoiceView: UIView {
    
    var examType: ExamType
    var viewModel: ExamViewModel
    
    // MARK: - UI
    lazy var handle = { () -> UIView in
        let handle = UIView()
        
        handle.backgroundColor = .lightGray
        
        return handle
    }()
    
    lazy var choiceStack = { () -> UIStackView in
        let row = UIStackView()
        
        row.axis = .vertical
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = 10
        
        return row
    }()
    
    lazy var title = { () -> UILabel in
        let label = UILabel()
        
        label.text = self.examType.getChoiceViewTitle()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    // MARK: - Initializer
    init(examType: ExamType, viewModel: ExamViewModel) {
        self.examType = examType
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .white
        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    private func buildConstraints() {
        self.addSubview(handle)
        self.addSubview(title)
        self.addSubview(choiceStack)
        
        handle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(60)
            make.height.equalTo(4)
        }
        handle.setViewCornerRadius(radius: 2)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(handle.snp.bottom).offset(15)
        }
        choiceStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(title.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    /// Choice의 순서를 맞춰서 넣을 것
    public func appendChoice(_ choice: PGChoiceView) {
        self.choiceStack.addArrangedSubview(choice)
    }
}
