//
//  QuestionNumber.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/14.
//

import UIKit
import SnapKit

class PGChoiceView: UIView {
    
    enum State {
        case selected
        case normal
        case wrong
        
        func getColor() -> (backgroundColor: UIColor?, tintColor: UIColor?, textColor: UIColor?) {
            switch self {
                case .selected:
                    return (.lightAccent, .accentColor, .white)
                case .normal:
                    return (.white, .lightAccent, .accentColor)
                case .wrong:
                    return (.wrongAnswerLight, .wrongAnswer, .white)
            }
        }
    }
    
    var state: State = .normal
    var number: Int
    var examType: ExamType
    var viewModel: ExamViewModel
    
    var originFrame: CGRect = .zero
    var originZPosition: CGFloat = .zero
    var keyboardFrame: CGRect = .zero
    var keyboardDuration: TimeInterval = 0.25
    var keyboardCurve: UIView.AnimationOptions = .curveEaseOut
    
    // MARK: - UI
    lazy var numberView = { () -> UIView in
        let numberView = UILabel()
        
        numberView.text = String(self.number)
        numberView.font = UIFont.boldSystemFont(ofSize: 20)
        numberView.textAlignment = .center
        
        numberView.textColor = self.state.getColor().textColor
        numberView.backgroundColor = self.state.getColor().tintColor
        
        numberView.clipsToBounds = true
        numberView.setViewCornerRadius(radius: CGFloat(45 / 2))
        
        return numberView
    }()
    
    lazy var choiceField = { () -> UITextField in
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.placeholder = "\(self.number)번 보기를 작성해주세요."
        field.tag = self.number
        field.delegate = self
        field.returnKeyType = .done
        
        field.text = self.viewModel.currentQuestion?.getChoice(of: "\(self.number)") ?? ""
        
        
        return field
    }()
    
    lazy var checkAnswer = { () -> UIButton in
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.setTitle(" 정답", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = self.number
        button.addTarget(self.viewModel, action: #selector(self.viewModel.toggleIsAnswer), for: .touchUpInside)
        
        if self.viewModel.currentQuestion!.answer.contains(self.number) {
            button.isSelected = true
        }
        
        return button
    }()
    
    lazy var createChoiceStack = { () -> UIStackView in
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        stack.addArrangedSubview(self.choiceField)
        stack.addArrangedSubview(self.checkAnswer)
        
        return stack
    }()

    // MARK: - Initializer
    init(number: Int, state: State = .normal, examType: ExamType, viewModel: ExamViewModel) {
        self.number = number
        self.state = state
        self.examType = examType
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.setViewCornerRadius(radius: 20)
        self.buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    private func buildConstraints() {
        self.addSubview(numberView)
        
        numberView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(45)
            make.width.equalTo(numberView.snp.height).multipliedBy(1.0 / 1.0)
        }
        
        switch self.examType {
            case .create:
                buildContraintsOfCreate()
            case .take:
                buildConstraintsOfTake()
            case .history:
                buildConstraintsOfHistory()
        }
    }
    
    private func buildContraintsOfCreate() {
        self.addSubview(createChoiceStack)
        
        createChoiceStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(numberView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func buildConstraintsOfTake() {
        
    }
    
    private func buildConstraintsOfHistory() {
        
    }
}

extension PGChoiceView: UITextFieldDelegate {
    
    @objc private func keyboardWillShow(notifiaction: NSNotification) {
        let userInfo = notifiaction.userInfo
        keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let animationCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? Int(UIView.AnimationOptions.curveEaseOut.rawValue)
        
        keyboardCurve = UIView.AnimationOptions(rawValue: UInt(animationCurve << 16))
        keyboardDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        originFrame = self.frame
        originZPosition = self.layer.zPosition
        
        textField.becomeFirstResponder()
        
        UIView.animate(withDuration: keyboardDuration, delay: .zero, options: keyboardCurve, animations: {
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 0.2
            self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            self.frame = CGRect(x: 0, y: self.keyboardFrame.minY + self.frame.height - 5, width: self.frame.width, height: self.frame.height)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        viewModel.currentQuestion?.choice["\(textField.tag)"] = text
        
        UIView.animate(withDuration: keyboardDuration, delay: .zero, options: keyboardCurve, animations: {
            self.frame = self.originFrame
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 0
        }, completion: { _ in
            self.layer.zPosition = self.originZPosition
            textField.resignFirstResponder()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
