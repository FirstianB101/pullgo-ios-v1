//
//  Styler.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

protocol Styler {
    func setDefaultButtonStyle(button: UIButton)
    func setViewShadow(view: UIView)
    func setViewCornerRadius(view: UIView)
    func setTextFieldPadding(field: UITextField)
}

extension Styler {
    func setDefaultButtonStyle(button: UIButton) {
        setViewCornerRadius(view: button)
        setViewShadow(view: button)
    }
    
    func setViewShadow(view: UIView) {
        let shadowOffset = CGSize(width: 1, height: 1)
        
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
    }
    
    func setViewCornerRadius(view: UIView) {
        let cornerRadius: CGFloat = view.frame.height / 2
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius
    }
    
    func setTextFieldPadding(field: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        field.leftView = paddingView
        field.leftViewMode = .always
    }
}
