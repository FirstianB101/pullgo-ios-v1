//
//  ExamTabBarPager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/03.
//

import UIKit

class ExamTabBarPager: UIView {
    
    let viewModel: ExamPagableViewModel
    let type: PagerType
    
    enum PagerType {
        case withoutSave
        case withSave
    }
    
    lazy var prevButton = { () -> UIButton in
        let prev = UIButton(type: .custom)
        
        prev.semanticContentAttribute = .forceLeftToRight
        prev.setTitleColor(.black, for: .normal)
        prev.tintColor = .black
        if let image = UIImage(systemName: "chevron.left") {
            prev.setImage(image, for: .normal)
        }
        prev.setTitle("이전 문제", for: .normal)
        prev.addTarget(self, action: #selector(self.presentPrevQuestion(_:)), for: .touchUpInside)
        
        return prev
    }()
    
    lazy var nextButton = { () -> UIButton in
        let next = UIButton(type: .custom)
        
        next.semanticContentAttribute = .forceRightToLeft
        next.setTitleColor(.black, for: .normal)
        next.tintColor = .black
        if let image = UIImage(systemName: "chevron.right") {
            next.setImage(image, for: .normal)
        }
        next.setTitle("다음 문제", for: .normal)
        next.addTarget(self, action: #selector(self.presentNextQuestion(_:)), for: .touchUpInside)
        
        return next
    }()
    
    lazy var saveButton = { () -> UIButton in
        let save = UIButton(type: .custom)
        
        save.setTitle("저장", for: .normal)
        save.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        save.addTarget(self, action: #selector(self.saveQuestions(_:)), for: .touchUpInside)
        
        return save
    }()
    
    let stackView = UIStackView()

    init(frame: CGRect = .zero, viewModel: ExamPagableViewModel, type: PagerType) {
        self.viewModel = viewModel
        self.type = type
        super.init(frame: frame)
        
        self.addSubview(prevButton)
        if self.type == .withSave { self.addSubview(saveButton) }
        self.addSubview(nextButton)
        
        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildConstraints() {
        prevButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        if self.subviews.contains(saveButton) {
            saveButton.snp.makeConstraints { make in
                make.top.centerX.bottom.equalToSuperview()
            }
        }
    }
    
    @objc
    func presentNextQuestion(_ sender: UIButton) {
        print("next question")
    }
    
    @objc
    func presentPrevQuestion(_ sender: UIButton) {
        print("prev question")
    }
    
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
