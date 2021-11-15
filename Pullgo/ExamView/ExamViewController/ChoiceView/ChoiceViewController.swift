//
//  ChoiceViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/13.
//

import UIKit

class ChoiceViewController: UIViewController {
    
    lazy var doneButton = { () -> UIButton in
        let button = UIButton()
        
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var initialCenter = CGPoint()
    var examType: ExamType
    var viewModel: ExamViewModel
    
    // MARK: - Initializer + override
    init(examType: ExamType, viewModel: ExamViewModel) {
        self.examType = examType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
        self.view = ChoiceViewFactory.getChoiceView(of: examType, viewModel: viewModel)
        self.addDoneButtonIfNeeded()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panSlide(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Method
    private func addDoneButtonIfNeeded() {
        guard let view = self.view as? ChoiceView else {
            print("self.view is not a ChoiceView.")
            return
        }
        self.view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view.title.snp.top)
            make.bottom.equalTo(view.title.snp.bottom)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
}

extension ChoiceViewController {
    
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
    
    @objc
    func dismissView() {
        let pvc = self.presentingViewController!
        pvc.view.gettingBright()
        dismiss(animated: true)
    }
}
