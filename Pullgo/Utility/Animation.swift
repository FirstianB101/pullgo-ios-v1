//
//  Animation.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/07.
//

import UIKit

extension UIView {
    
    func vibrate() {
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: 3, y: 0)
        })
        animator.addAnimations ({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.1)
        animator.startAnimation()
    }
    
    func slowAppear() {
        if self.alpha == 1 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.show()
        })
    }
    
    func slowDisappear() {
        if self.alpha == 0 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.hide()
        })
    }
    
    /// Make view.alpha property to 0.3 with animate
    func gettingDark() {
        if self.alpha == 0.3 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.3
        })
    }
    
    /// Make view.alpha property to 1 with animate
    func gettingBright() {
        if self.alpha == 1 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })
    }
    
    func popUp() {
        DispatchQueue.main.async {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            animator.addAnimations ({
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
            }, delayFactor: 0.1)
            animator.startAnimation()
        }
    }
    
    func popDown(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            animator.addAnimations({
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.alpha = 0
            }, delayFactor: 0.1)
            animator.addCompletion { _ in
                completion()
            }
            animator.startAnimation()
        }
    }
}
