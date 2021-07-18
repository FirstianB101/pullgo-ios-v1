//
//  TeacherRequestClassroomJoinViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/17.
//

import UIKit

class TeacherRequestClassroomJoinViewController: UIViewController {
    
    let viewModel = TeacherRequestClassroomJoinViewModel()
    @IBOutlet weak var classroomTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.networkAlertDelegate = self
        self.dismissKeyboard()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }

}

extension TeacherRequestClassroomJoinViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TeacherRequestClassroomJoinViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomCell") as! TeacherClassroomCell
        let classroomParse = viewModel.classrooms[indexPath.row].parseClassroomName()
        
        cell.teacherNameLabel.text = classroomParse.teacherName
        cell.weekdayLabel.text = classroomParse.weekday
        cell.classroomNameLabel.text = classroomParse.classroomName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.classrooms.count
    }
}

extension TeacherRequestClassroomJoinViewController: UISearchBarDelegate, NetworkAlertDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchBar.text else { return }
        viewModel.searchClassroom(by: input) {
            if self.viewModel.classrooms.isEmpty {
                let alert = AlertPresentor(view: self)
                alert.present(title: "\(input)", context: "검색 결과가 없습니다.")
            }
            self.classroomTableView.reloadData()
        }
    }
    
    func networkFailAlert() {
        let alert = AlertPresentor(view: self)
        alert.presentNetworkError()
    }
}

class TeacherRequestClassroomJoinViewModel {
    var classrooms: [Classroom] = []
    var networkAlertDelegate: NetworkAlertDelegate?
    
    func searchClassroom(by input: String, complete: @escaping EmptyClosure) {
        var url: URL = NetworkManager.assembleURL(components: ["academy", "classrooms"])
        url.appendQuery(queryItems: [URLQueryItem(name: "nameLike", value: input),
                                     URLQueryItem(name: "academyId", value: String((SignedUser.signedAcademy?.id)!))])
        
        let success: ResponseClosure = { data in
            guard let receivedClassrooms = try? data?.toObject(type: [Classroom].self) else {
                print("TeacherRequestClassroomJoinViewModel.searchClassroom() -> data parse error")
                return
            }
            self.classrooms = receivedClassrooms
        }
        
        let fail: FailClosure = {
            self.networkAlertDelegate?.networkFailAlert()
        }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
}
