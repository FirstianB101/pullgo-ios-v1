//
//  PGSelectionTap.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/12.
//

import UIKit
import SnapKit

class PGSelectionTab: UIView {
    
    let height = 35
    
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
        self.backgroundColor = UIColor(named: "LightAccent")!
    }
    
    func setConstraints(by viewController: UIViewController) {
        var top: CGFloat
        if let navCon = viewController.navigationController {
            top = navCon.navigationBar.frame.maxY
        } else {
            top = viewController.view.frame.minY
        }
        
        self.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(top)
            make.height.equalTo(self.height)
        }
    }
}
