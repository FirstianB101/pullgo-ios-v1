//
//  TeacherMenuViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/15.
//

import UIKit
import SideMenu

class TeacherMenuViewController: UIViewController {

    let animator = AnimationPresentor()
    let viewModel = TeacherMenuViewModel()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var academyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabels()
    }
    
    func setLabels() {
        nameLabel.text = """
        \(viewModel.fullName)님,
        안녕하세요!
        """
        academyLabel.text = viewModel.academyName
    }
}

extension TeacherMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TeacherViewSwitcher.switchView(self, presenting: TeacherMenu.value(at: indexPath.row))
    }
}

extension TeacherMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherMenuCell") as! TeacherMenuCell
        
        cell.menuTitleLabel.text = viewModel.menus[indexPath.row]
        return cell
    }
    
    
}

class TeacherMenuViewModel {
    let fullName: String = SignedUser.teacher.account.fullName
    let academyName: String = SignedUser.signedAcademy?.name ?? ""
    var menus: [String] = []
    
    init() {
        for menu in TeacherMenu.allCases {
            // Conditions have to be added
            menus.append(menu.rawValue)
        }
    }
}

class TeacherMenuCell: UITableViewCell {
    @IBOutlet weak var menuTitleLabel: UILabel!
}
