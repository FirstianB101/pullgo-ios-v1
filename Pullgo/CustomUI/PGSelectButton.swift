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
    
    private var selectState: State = .deselect
    
    var deselectTitle: String?
    var selectedTitle: String?
    var selectedSubtitle: String?
    
    let selectedTitleLabel = UILabel()
    let selectedSubtitleLabel = UILabel()
    
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
    
    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
        deselectTitle = title
    }
    
    private func setStyle() {
        self.setViewCornerRadius(view: self, radius: 15)
        self.setViewShadow(view: self)
        setUIDeselect()
        
        addArrowImage()
        setLabels()
    }
    
    private func setUIDeselect() {
        self.backgroundColor = UIColor(named: "LightAccent")!
        
        self.setTitle(self.deselectTitle, for: .normal)
        selectedTitleLabel.isHidden = true
        selectedSubtitleLabel.isHidden = true
    }
    
    private func setUISelected() {
        self.backgroundColor = UIColor(named: "SelectedColor")!
        
        self.setTitle("", for: .normal)
        selectedTitleLabel.isHidden = false
        selectedSubtitleLabel.isHidden = false
    }
    
    private func setLabels() {
        self.addSubview(selectedTitleLabel)
        self.addSubview(selectedSubtitleLabel)
        
        setSelectedTitleConstraints(selectedTitleLabel)
        setSelectedSubtitleConstraints(selectedSubtitleLabel)
    }
    
    private func setSelectedTitleConstraints(_ label: UILabel) {
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(-13)
            make.trailing.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(-20)
        }
    }
    
    private func setSelectedSubtitleConstraints(_ label: UILabel) {
        label.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-13)
            make.trailing.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(-20)
        }
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
        
        if state == .deselect {
            setUIDeselect()
        } else if state == .selected {
            setUISelected()
        }
    }
    
    public func setSelectedTitle(_ title: String) {
        self.selectedTitle = title
        self.selectedTitleLabel.text = title
    }
    
    public func setSelectedSubtitle(_ subtitle: String) {
        self.selectedSubtitle = subtitle
        self.selectedSubtitleLabel.text = subtitle
    }
}
