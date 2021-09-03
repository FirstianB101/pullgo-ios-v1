//
//  PGButton.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/31.
//

import UIKit

@IBDesignable
public class PGButton: UIButton, Styler {
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        setStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    init() {
        super.init(frame: .zero)
        setStyle()
    }
    
    private func setStyle() {
        setViewCornerRadius(view: self)
        setViewShadow(view: self)
        self.backgroundColor = UIColor(named: "AccentColor")!
        self.tintColor = .white
    }
}
