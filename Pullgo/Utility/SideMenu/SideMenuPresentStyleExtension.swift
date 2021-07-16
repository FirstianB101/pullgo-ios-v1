//
//  SideMenuPresentStyle.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/16.
//

import UIKit
import SideMenu

class CustomSideMenuStyle: SideMenuPresentationStyle {
    required init() {
        super.init()
        /// Background color behind the views and status bar color
//        backgroundColor = .black
        /// The starting alpha value of the menu before it appears
        menuStartAlpha = 1
        /// Whether or not the menu is on top. If false, the presenting view is on top. Shadows are applied to the view on top.
        menuOnTop = true
        /// The amount the menu is translated along the x-axis. Zero is stationary, negative values are off-screen, positive values are on screen.
        menuTranslateFactor = -1
        /// The amount the menu is scaled. Less than one shrinks the view, larger than one grows the view.
        menuScaleFactor = 1
        /// The color of the shadow applied to the top most view.
        onTopShadowColor = .black
        /// The radius of the shadow applied to the top most view.
        onTopShadowRadius = 5
        /// The opacity of the shadow applied to the top most view.
        onTopShadowOpacity = 0
        /// The offset of the shadow applied to the top most view.
        onTopShadowOffset = .zero
        /// The ending alpha of the presenting view when the menu is fully displayed.
        presentingEndAlpha = 0.3
        /// The amount the presenting view is translated along the x-axis. Zero is stationary, negative values are off-screen, positive values are on screen.
        presentingTranslateFactor = 0
        /// The amount the presenting view is scaled. Less than one shrinks the view, larger than one grows the view.
        presentingScaleFactor = 1
        /// The strength of the parallax effect on the presenting view once the menu is displayed.
        presentingParallaxStrength = .zero
    }
}
