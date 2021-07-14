//
//  AlertPresentor.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import UIKit

class AnimationPresentor: Styler {
    func vibrate(view: UIView) {
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.1, animations: {
            view.transform = CGAffineTransform(translationX: 3, y: 0)
        })
        animator.addAnimations ({
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.1)
        animator.startAnimation()
    }
    
    func slowAppear(view: UIView) {
        if view.alpha == 1 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.show(view: view)
        })
    }
    
    func slowDisappear(view: UIView) {
        if view.alpha == 0 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.hide(view: view)
        })
    }
}

class AlertPresentor {
    let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func present(title: String, context: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlert(title: title, context: context)
        let action = UIAlertAction(title: "확인", style: .default, handler: handler)
        
        alert.addAction(action)
        self.view.present(alert, animated: true, completion: nil)
    }
    
    func present(title: String, context: String, actions: [UIAlertAction]) {
        if actions.isEmpty { return }
        
        let alert = getAlert(title: title, context: context)
        
        for action in actions {
            alert.addAction(action)
        }
        self.view.present(alert, animated: true, completion: nil)
    }
    
    func present(title: String, context: Message, handler: ((UIAlertAction) -> Void)? = nil) {
        self.present(title: title, context: context.rawValue, handler: handler)
    }
    
    func present(title: String, context: Message, actions: [UIAlertAction]) {
        self.present(title: title, context: context.rawValue, actions: actions)
    }
    
    func presentNetworkError() {
        self.present(title: "오류", context: .NetworkError)
    }
    
    private func getAlert(title: String, context: String) -> UIAlertController {
        return UIAlertController(title: title, message: context, preferredStyle: .alert)
    }
}
