//
//  PGUnregisteredNotification.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/24.
//

import UIKit

class PGUnregisteredNotification: UIView {
    
    private var notificationLabel = UILabel()
    private var action = UIButton()
    private let stack = UIStackView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.stack.axis = .vertical
        stack.addSubview(notificationLabel)
        stack.addSubview(action)
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 100
    }
    
    public func setText(_ text: String) {
        self.notificationLabel.text = text
        self.notificationLabel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    public func setAction(_ title: String, target: Any?, selector: Selector) {
        self.action.setTitle(title, for: .normal)
        self.action.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.action.addTarget(target, action: selector, for: .touchUpInside)
    }
}
