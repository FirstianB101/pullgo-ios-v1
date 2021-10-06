//
//  ButtonBarPagerExtension.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/06.
//

import XLPagerTabStrip

extension ButtonBarPagerTabStripViewController {
    func setDefaultSettings() {
        guard let lightAccent = UIColor(named: "LightAccent"),
              let selectedColor = UIColor(named: "SelectedColor"),
              let accent = UIColor(named: "AccentColor")
        else { return }
       
        settings.style.buttonBarBackgroundColor = selectedColor
        settings.style.buttonBarItemBackgroundColor = lightAccent
        settings.style.selectedBarBackgroundColor = accent
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.contentOffset = CGPoint(x: 0, y: 0)
        buttonBarView.bounces = false
    }
}
