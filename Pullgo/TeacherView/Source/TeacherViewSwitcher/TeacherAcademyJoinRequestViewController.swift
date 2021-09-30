//
//  TeacherAcademyJoinRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/30.
//

import UIKit

class TeacherAcademyJoinRequestViewController: UIViewController {
    let viewModel = TeacherAcademyJoinRequestViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var academyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.academyTableView.delegate = self
        self.academyTableView.dataSource = self
        
        searchBar.becomeFirstResponder()
    }
}

extension TeacherAcademyJoinRequestViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nameLike = searchBar.text else { return }
        print(nameLike)
        
        viewModel.getAcademies(by: nameLike) {
            if self.viewModel.academies.isEmpty {
                let alert = PGAlertPresentor(presentor: self)
                alert.present(title: "알림", context: "일치하는 학원이 없습니다.")
            }
            
            self.academyTableView.reloadData()
        }
    }
}

extension TeacherAcademyJoinRequestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAcademy = viewModel.academies[indexPath.row]
        
        requestApplyAcademy(selectedAcademy)
    }
    
    private func requestApplyAcademy(_ selectedAcademy: Academy) {
        let academyName: String = selectedAcademy.name.hasSuffix("학원") ? selectedAcademy.name : selectedAcademy.name.appending("학원")
        
        let alert = PGAlertPresentor(presentor: self)
        
        let apply = UIAlertAction(title: "요청", style: .default) { _ in
            PGSignedUser.applyAcademy(academyId: selectedAcademy.id!) { _ in
                alert.present(title: "알림", context: "\(academyName)에 가입을 요청하였습니다.")
            }
        }
        
        alert.present(title: "알림",
                      context: "\(academyName)에 가입을 요청할까요?",
                      actions: [alert.cancel, apply])
    }
}

extension TeacherAcademyJoinRequestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.academies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherAcademyJoinRequest") as? AcademyTableViewCell else { return UITableViewCell() }
        
        let academy = viewModel.academies[indexPath.row]
        
        cell.academyAddress.text = academy.address
        cell.academyName.text = academy.name
        cell.academyPhone.text = academy.phone
        
        return cell
    }
}

class TeacherAcademyJoinRequestViewModel {
    var academies: [Academy] = []
    
    public func getAcademies(by nameLike: String, complete: @escaping (() -> Void)) {
        let url = PGURLs.academies
            .appendingQuery([URLQueryItem(name: "nameLike", value: nameLike)])
        
        PGNetwork.get(url: url, type: [Academy].self) { academies in
            self.academies = academies
            complete()
        }
    }
}

class AcademyTableViewCell: UITableViewCell {
    @IBOutlet weak var academyAddress: UILabel!
    @IBOutlet weak var academyPhone: UILabel!
    @IBOutlet weak var academyName: UILabel!
}
