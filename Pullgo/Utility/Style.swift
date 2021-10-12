//
//  Style.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit

extension UIView {
    var margin: CGFloat { 30 }
    var defaultCornerRadius: CGFloat { self.frame.height / 2 }
    
    func setViewShadow() {
        let shadowOffset = CGSize(width: 1, height: 1)
        
        self.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
    }
    
    func setViewCornerRadius(radius: CGFloat? = nil) {
        let cornerRadius: CGFloat = radius ?? self.frame.height / 2
        self.layer.cornerRadius = cornerRadius
    }
    
    func setViewCornerRadiusAndShadow(radius: CGFloat? = nil) {
        self.setViewCornerRadius(radius: radius)
        self.setViewShadow()
    }
    
    func hide() {
        self.alpha = 0
    }
    
    func show() {
        self.alpha = 1
    }
}

extension UITextField {
    func setTextFieldBorderUnderline() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width - margin, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
    
    func setTextFieldPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UICollectionViewCell {
    
    func setCellUI() {
        self.contentView.layer.cornerRadius = 25.0
        self.contentView.layer.borderWidth = 0
        self.contentView.layer.masksToBounds = true;
        self.contentView.layer.backgroundColor = UIColor.white.cgColor
    }
}

extension UICollectionView {
    
    func setCollectionViewBackgroundColor() {
        if let color = UIColor(named: "CollectionViewBackground") {
            self.backgroundColor = color
        }
    }
}
