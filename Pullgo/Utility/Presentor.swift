//
//  AlertPresentor.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import UIKit

class AnimationPresentor {
    func vibrate(view: UIView) {
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.1, animations: {
            view.transform = CGAffineTransform(translationX: 3, y: 0)
        })
        animator.addAnimations ({
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.1)
        animator.startAnimation()
    }
}

class AlertPresentor {
    let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func present(title: String, context: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: context, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: handler)
        
        alert.addAction(action)
        self.view.present(alert, animated: true, completion: nil)
    }
}
