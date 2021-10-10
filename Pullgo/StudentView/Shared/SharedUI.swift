//
//  SharedUI.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class PGTitleBar: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    init() {
        super.init(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        initUI()
    }
    
    convenience init(title: String, frame: CGRect) {
        self.init()
        initUI(title: title)
    }
    
    private func initUI(title: String = "") {
        self.addSubview(navigationBar(title))
    }
    
    lazy var navigationBar = { (title: String) -> UINavigationBar in
        let navigationBar = UINavigationBar()
        navigationBar.tintColor = .white
        navigationBar.topItem?.title = title
        
        let sideMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(self.showSideMenu))
        navigationBar.topItem?.setLeftBarButton(sideMenuButton, animated: false)
        
        return navigationBar
    }
    
    @objc func showSideMenu() {
        if let superVC = self.superViewController {
            StudentViewSwitcher.showSideMenu(superVC)
        }
    }
}

extension UIView {
    
    var superViewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.superViewController
        } else {
            return nil
        }
    }
}
