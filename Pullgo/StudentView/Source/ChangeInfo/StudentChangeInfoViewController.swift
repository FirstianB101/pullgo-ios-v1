//
//  StudentChangeInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentChangeInfoViewController: UIViewController {
    
    let viewModel = StudentChangeInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
    
    @IBAction func presentChangeInfoClicked(_ sender: PGButton) {
        viewModel.checkPassword(correct: {
            self.presentChangeInfoView()
        }, incorrect: {
            self.presentIncorrectPasswordAlert()
        })
    }
    
    private func presentChangeInfoView() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "StudentChangeInfoNavigationController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    private func presentIncorrectPasswordAlert() {
        let alert = PGAlertPresentor()
        alert.present(title: "알림", context: "비밀번호가 일치하지 않습니다.")
    }
}

class StudentChangeInfoViewModel {
    
    public func checkPassword(correct: @escaping (() -> Void), incorrect: @escaping (() -> Void)) {
        let gen = Int.random(in: 0...10)
        
        gen < 7 ? correct() : incorrect()
    }
}
