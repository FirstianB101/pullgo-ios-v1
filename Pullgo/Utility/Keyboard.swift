//
//  Extension.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

extension UIViewController {
    func setKeyboardWatcher() {
        keyboardWatcher(show: #selector(keyboardWillShow), hide: #selector(keyboardWillHide))
        self.setDismissKeyboardEnable()
    }
    
    func keyboardWatcher(show: Selector, hide: Selector) {
        NotificationCenter.default.addObserver(self, selector: show, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hide, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notifiaction: NSNotification) {
        if let keyboardSize = (notifiaction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= CGFloat(keyboardSize.height - view.bounds.height / 4.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = .zero
        }
    }
    
    func setDismissKeyboardEnable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
