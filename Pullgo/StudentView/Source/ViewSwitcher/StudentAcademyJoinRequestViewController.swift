//
//  StudentAcademyJoinRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentAcademyJoinRequestViewController: UIViewController {

    @IBOutlet weak var academyTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = StudentAcademyJoinRequestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StudentAcademyJoinRequestViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        self.viewModel.searchAcademy(by: query) { [unowned self] in
            let alert = PGAlertPresentor()
            
            if self.viewModel.getAcademies().isEmpty {
                alert.present(title: "알림", context: "일치하는 학원이 없습니다.")
            } else {
                self.academyTableView.reloadData()
            }
        }
    }
}

extension StudentAcademyJoinRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let academyName = viewModel.getAcademy(at: indexPath.row).name!
        
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "요청", style: .default) { [weak self] _ in
            self?.viewModel.sendJoinRequest(at: indexPath.row) {
                alert.present(title: "알림", context: "\(academyName)에 가입 요청을 보냈습니다.")
            }
        }
        
        alert.present(title: "알림",
                      context: "\(academyName)에 가입 요청을 보낼까요?",
                      actions: [alert.cancel, okay])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAcademies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcademyTableViewCell") as? AcademyTableViewCell else { return UITableViewCell() }
        
        let academy = viewModel.getAcademy(at: indexPath.row)
        cell.academyName.text = academy.name
        cell.academyPhone.text = academy.phone
        cell.academyAddress.text = academy.address
        
        return cell
    }
}

class StudentAcademyJoinRequestViewModel {
    private var academies: [Academy] = []
    private var page: Int = 0
    
    public func searchAcademy(by nameLike: String, complete: @escaping (() -> Void)) {
        let url = PGURLs.academies
            .pagination(page: self.page)
            .appendingQuery([URLQueryItem(name: "nameLike", value: nameLike)])
        
        PGNetwork.get(url: url, type: [Academy].self) { [weak self] academies in
            self?.academies = academies
            complete()
        }
    }
    
    public func getAcademies() -> [Academy] { return self.academies }
    public func getAcademy(at index: Int) -> Academy { return self.academies[index] }
    
    public func sendJoinRequest(at index: Int, complete: @escaping (() -> Void)) {
        PGSignedUser.applyAcademy(academyId: self.academies[index].id!) { _ in
            complete()
        }
    }
}
