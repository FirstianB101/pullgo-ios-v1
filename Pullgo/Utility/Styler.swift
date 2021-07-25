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
    func setTextFieldBorderUnderline(field: UITextField)
}

extension Styler {
    var margin: CGFloat { get { return 30 } }
    
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
    }
    
    func setViewCornerRadius(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    func setTextFieldPadding(field: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        field.leftView = paddingView
        field.leftViewMode = .always
    }
    
    func setTextFieldBorderUnderline(field: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.bounds.width - margin, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        field.borderStyle = .none
        field.layer.addSublayer(bottomLine)
    }
    
    func setCellUI(cell: UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 25.0
        cell.contentView.layer.borderWidth = 0.2
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.contentView.layer.backgroundColor = UIColor.white.cgColor
        
        cell.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 2, height: 2.0)
        cell.layer.shadowRadius = 2
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false;
    }
    
    func hide(view: UIView) {
        view.alpha = 0
    }
    
    func show(view: UIView) {
        view.alpha = 1
    }
}
