//
//  ExamTabBarPager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/03.
//

import UIKit

class ExamTabBarPager: UIView {
    
    let viewModel: ExamPagableViewModel
    
    lazy var prevButton = { () -> UIButton in
        let prev = UIButton(type: .custom)
        
        prev.semanticContentAttribute = .forceLeftToRight
        prev.setTitleColor(.black, for: .normal)
        prev.setTitleColor(.lightGray, for: .disabled)
        prev.tintColor = .black
        if let image = UIImage(systemName: "chevron.left") {
            prev.setImage(image, for: .normal)
        }
        prev.setTitle("이전 문제", for: .normal)
        
        return prev
    }()
    
    lazy var nextButton = { () -> UIButton in
        let next = UIButton(type: .custom)
        
        next.semanticContentAttribute = .forceRightToLeft
        next.setTitleColor(.black, for: .normal)
        next.setTitleColor(.lightGray, for: .disabled)
        next.tintColor = .black
        if let image = UIImage(systemName: "chevron.right") {
            next.setImage(image, for: .normal)
        }
        next.setTitle("다음 문제", for: .normal)
        
        return next
    }()
    
    let stackView = UIStackView()

    init(frame: CGRect = .zero, viewModel: ExamPagableViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        self.addSubview(prevButton)
        self.addSubview(nextButton)
        setPagerButtonStatus()
        
        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Method
    private func buildConstraints() {
        prevButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    public func addNextQuestionTarget(_ target: Any?, action: Selector) {
        self.nextButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func addPrevQuestionTarget(_ target: Any?, action: Selector) {
        self.prevButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setPagerButtonStatus() {
        if viewModel.isFirstQuestion {
            prevButton.isEnabled = false
        } else if viewModel.isLastQuestion {
            nextButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
            nextButton.isEnabled = true
        }
        
        prevButton.isEnabled = !viewModel.isFirstQuestion
        nextButton.isEnabled = !viewModel.isLastQuestion
    }
}
