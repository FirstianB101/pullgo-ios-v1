//
//  HistoryContainerView.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/10.
//

import UIKit
import SnapKit

class CreateContainerView: UIView, ContainerView {
    
    
    // MARK: - UI
    lazy var questionContent = { () -> UITextView in
        let textView = UITextView()
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.2
        textView.textContainer.lineFragmentPadding = 10
        textView.setViewCornerRadius(radius: 15)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.addDismissToolbar()
        textView.delegate = self
        
        // placeholder
        textView.textColor = .lightGray
        textView.text = "문제를 입력해주세요."
        
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
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "LightAccent")
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitle(" 여기를 눌러 사진을 추가하세요.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.setViewCornerRadiusAndShadow(radius: 20)
        
        return button
    }()
    
    lazy var imageContentStack = { () -> UIStackView in
        let stack = UIStackView()
        
        stack.axis = .vertical
        
        return stack
    }()
    
    lazy var editChoicesButton = { () -> UIButton in
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(named: "LightAccent")
        button.setTitle("보기 작성", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setViewCornerRadiusAndShadow(radius: 25)
        button.addTarget(self, action: #selector(CreateQuestionViewController.editChoice(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Property + Initializer
    var question: Question?
    let maxContentLength: Int = 200
    
    required init(question: Question?) {
        self.question = question
        super.init(frame: .zero)
        self.buildContraints()
        self.setContents()
        self.setBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackground() {
        self.backgroundColor = .white
    }
    
    private func buildContraints() {
        self.addSubview(questionContentStack)
        self.addSubview(addImageButton)
        self.addSubview(editChoicesButton)
        
        questionContentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.addImageButton.snp.top).offset(-30)
        }
        addImageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.editChoicesButton.snp.top).offset(-30)
            make.height.equalTo(40)
        }
        editChoicesButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    private func setContents() {
        self.questionContent.text = question?.content ?? ""
    }
}

// TextView Placeholder
extension CreateContainerView: UITextViewDelegate {
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
        
        if count > maxContentLength {
            textView.text.removeLast()
            questionLength.vibrate()
            return
        }
        
        questionLength.text = "\(count)/\(maxContentLength)자"
    }
}
