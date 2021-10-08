//
//  StudentSideMenuViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit
import SideMenu
import SnapKit

class StudentSideMenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var academyNameLabel: UILabel!
    
    let viewModel = StudentSideMenuViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
    }
    
    private func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        PGSignedUser.logout()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = self.presentingViewController!
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.dismiss(animated: true) { [weak self] in
            self?.viewModel.removeAutoLoginInfo()
            pvc.present(vc, animated: true, completion: nil)
        }
    }
}

extension StudentSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StudentViewSwitcher.switchView(self, presenting: .value(at: indexPath.row))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMenus().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentSideMenuCell") as? StudentSideMenuCell else { return UITableViewCell() }
        
        cell.menuLabel.text = viewModel.getMenu(at: indexPath.row)
        
        return cell
    }
}

class StudentSideMenuCell: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
}

class StudentSideMenuViewModel {
    private var name: String = PGSignedUser.student.account.fullName
    private var academyName: String = PGSignedUser.selectedAcademy.name ?? "가입된 학원이 없습니다."
    private var menus: [String] = []
    
    init() {
        if PGSignedUser.selectedAcademy == nil {
            menus.append(StudentMenu.changeInfo.rawValue)
            return
        }
        
        for menu in StudentMenu.allCases {
            menus.append(menu.rawValue)
        }
    }
    
    public func getNameAndGreeting() -> String {
        return """
        \(self.name)님,
        안녕하세요!
        """
    }
    
    public func getAcademyName() -> String {
        return self.academyName
    }
    
    public func getMenus() -> [String] {
        return menus
    }
    
    public func getMenu(at index: Int) -> String {
        return menus[index]
    }
    
    public func removeAutoLoginInfo() {
        
    }
}
