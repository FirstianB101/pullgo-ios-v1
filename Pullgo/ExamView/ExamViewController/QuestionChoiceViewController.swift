//
//  QuestionChoiceViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/05.
//

import UIKit
import SnapKit

class QuestionChoiceViewController: UIViewController {
    
    var initialCenter = CGPoint()
    
    lazy var topHandle = { () -> UIView in
        let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    enum ViewType: String {
        case take = "정답 체크"
        case create = "보기 작성"
        case history = "정답 확인"
    }
    
    init(viewType: ViewType) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = viewType.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panSlide(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.view.backgroundColor = .white
        
        buildConstraints()
    }
    
    private func buildConstraints() {
        setHandleConstraints()
        setTitleConstraints()
    }
    
    private func setHandleConstraints() {
        self.view.addSubview(topHandle)
        topHandle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(5)
        }
        topHandle.setViewCornerRadius(radius: 2.5)
    }
    
    private func setTitleConstraints() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topHandle.snp.bottom).offset(15)
        }
    }
}

extension QuestionChoiceViewController {
    
    @objc
    func panSlide(_ sender: UIPanGestureRecognizer) {
            
        if self.view.center.y > self.view.bounds.height * 1.2 && sender.state == .ended {
            dismissView()
            return
        }
        
        if sender.state == .began || sender.state == .changed {
            if self.view.center.y >= initialCenter.y {
                let transition = sender.translation(in: self.view)
                let moveY = self.view.center.y + transition.y
                
                if self.view.center.y == initialCenter.y {
                    if moveY < 0 { return }
                }
                
                self.view.center = CGPoint(x: initialCenter.x, y: moveY)
                
            }
            sender.setTranslation(.zero, in: self.view)
        }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.center = self.initialCenter
            })
        }
    }
    
    func dismissView() {
        let pvc = self.presentingViewController!
        dismiss(animated: true) {
            pvc.view.gettingBright()
        }
    }
}
