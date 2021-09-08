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
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        selectedTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        selectedSubtitleLabel.font = UIFont.systemFont(ofSize: 15)
        selectedSubtitleLabel.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func setSelectedTitleConstraints(_ label: UILabel) {
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(13)
            make.trailing.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
        }
    }
    
    private func setSelectedSubtitleConstraints(_ label: UILabel) {
        label.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-13)
            make.trailing.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
        }
    }
    
    private func addArrowImage() {
        let arrow = UIImage(systemName: "chevron.right")!
        let arrowView = UIImageView(image: arrow)
        
        self.addSubview(arrowView)
        
        arrowView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.size.equalTo(CGSize(width: 10, height: 15))
            make.centerY.equalTo(self)
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
    
    public func setDeselectedTitle(_ title: String) {
        self.deselectTitle = title
        self.setTitle(title, for: .normal)
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
