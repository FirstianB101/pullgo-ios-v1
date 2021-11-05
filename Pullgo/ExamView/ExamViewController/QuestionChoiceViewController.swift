//
//  QuestionChoiceViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/05.
//

import UIKit

class QuestionChoiceViewController: UIViewController {
    
    var initialCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panSlide(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        self.view.backgroundColor = .white
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
