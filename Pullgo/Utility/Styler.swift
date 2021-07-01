//
//  Styler.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

class Styler {
    static func setDefaultButtonStyle(button: UIButton) {
        setViewCornerRadius(view: button)
        setViewShadow(view: button)
    }
    
    static func setViewShadow(view: UIView) {
        let shadowOffset = CGSize(width: 1, height: 1)
        
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
    }
    
    static func setViewCornerRadius(view: UIView) {
        let cornerRadius: CGFloat = view.frame.height / 2
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius
    }
    
    static func setTextFieldPadding(field: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        field.leftView = paddingView
        field.leftViewMode = .always
    }
}
