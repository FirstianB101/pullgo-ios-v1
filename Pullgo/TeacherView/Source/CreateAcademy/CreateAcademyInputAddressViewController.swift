//
//  CreateAcademyInputAddressViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/16.
//

import UIKit

class CreateAcademyInputAddressViewController: UIViewController {
    
    @IBOutlet weak var roadAddress: PGTextField!
    @IBOutlet weak var detailAddress: PGTextField!
    
    weak var viewModel: CreateAcademyViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func createAcademyClicked(_ sender: UIButton) {
        guard self.checkAllFieldValid(fields: [roadAddress, detailAddress]) else { return }
        guard let viewModel = self.viewModel else { return }
        guard let pvc = self.presentingViewController as? CreateAcademyViewController else { return }
        
        viewModel.roadAddress = roadAddress.text!
        viewModel.detailAddress = detailAddress.text!
        
        viewModel.createAcademy { [weak self] in
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "학원이 생성되었습니다.") { _ in
                self?.dismiss(animated: true, completion: {
                    pvc.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}
