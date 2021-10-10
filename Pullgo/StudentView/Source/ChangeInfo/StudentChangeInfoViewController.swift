//
//  StudentChangeInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentChangeInfoViewController: UIViewController {
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
}
