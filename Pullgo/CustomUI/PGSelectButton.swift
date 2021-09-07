//
//  PGSelectButton.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/07.
//

import UIKit
import SnapKit

class PGSelectButton: UIButton {
    
    enum State: Int {
        case deselect = 0
        case selected
    }
    
    var selectState: State = .deselect
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        self.setViewCornerRadius(view: self, radius: 15)
        self.setViewShadow(view: self)
        self.backgroundColor = UIColor(named: "LightAccent")
        
        addArrowImage()
    }
    
    private func addArrowImage() {
        let arrow = UIImage(named: "chevron.right")
        let arrowView = UIImageView(image: arrow)
        
        self.addSubview(arrowView)
        
        arrowView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-30)
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalTo(self.frame.midY)
        }
    }
    
    public func setState(for state: PGSelectButton.State) {
        self.selectState = state
    }
}
