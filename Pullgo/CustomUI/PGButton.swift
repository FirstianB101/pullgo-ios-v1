//
//  PGButton.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/31.
//

import UIKit
import SnapKit

public class PGButton: UIButton {
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
        self.setViewCornerRadiusAndShadow()
        self.backgroundColor = UIColor(named: "AccentColor")!
        self.tintColor = .white
    }
}
