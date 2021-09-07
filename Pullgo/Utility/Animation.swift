//
//  Animation.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/07.
//

import UIKit

extension UIView: Styler {

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
            self.show(view: self)
        })
    }
    
    func slowDisappear() {
        if self.alpha == 0 { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.hide(view: self)
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
}
