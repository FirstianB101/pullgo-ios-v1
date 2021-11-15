//
//  CreateAcademyViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/11/16.
//

import UIKit

class CreateAcademyViewController: UIViewController {
    
    @IBOutlet weak var academyNameField: PGTextField!
    @IBOutlet weak var academyPhoneField: PGTextField!
    
    let viewModel = CreateAcademyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardDismissWatcher()
    }
    
    @IBAction func next(_ sender: PGButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CreateAcademyInputAddressViewController") as? CreateAcademyInputAddressViewController else { return }
        
        guard self.checkAllFieldValid(fields: [academyNameField, academyPhoneField]) else { return }
        guard academyPhoneField.text!.isPhoneValid else {
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "올바르지 않은 전화번호 형식입니다.")
            return
        }
        
        self.viewModel.setName(academyNameField.text!)
        self.viewModel.setPhone(academyPhoneField.text!)
        
        vc.viewModel = self.viewModel
        
        self.present(vc, animated: true, completion: nil)
    }
}

class CreateAcademyViewModel {
    
    let academy: Academy
    
    var roadAddress = ""
    var detailAddress = ""
    
    init() {
        academy = Academy()
        academy.ownerId = PGSignedUser.id
    }
    
    public func setName(_ name: String) {
        self.academy.name = name
    }
    
    public func setPhone(_ phone: String) {
        self.academy.phone = phone
    }
    
    public func setRoadAddress(_ address: String) {
        self.roadAddress = address
    }
    
    public func setDetailAddress(_ address: String) {
        self.detailAddress = address
    }
    
    public func createAcademy(completion: @escaping (() -> Void)) {
        self.academy.address = "\(roadAddress) \(detailAddress)"
        self.academy.post(success: { _ in
            PGSignedUser.getAcademies(page: 0, completion: { _ in
                completion()
            })
        })
    }
}
