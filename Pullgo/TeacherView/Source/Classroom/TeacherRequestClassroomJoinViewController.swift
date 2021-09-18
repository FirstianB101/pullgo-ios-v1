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
        self.setDismissKeyboardEnable()
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }

}

extension TeacherRequestClassroomJoinViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = PGAlertPresentor(presentor: self)
        let apply = UIAlertAction(title: "요청", style: .default, handler: { _ in
            self.requestClassroomJoin(id: self.viewModel.getClassroomId(at: indexPath.row))
        })

        alert.present(title: "\(viewModel.getClassroomName(at: indexPath.row))", context: "반 가입을 요청할까요?", actions: [alert.cancel, apply])
    }
    
    private func requestClassroomJoin(id: Int) {
        let url = NetworkManager.assembleURL("teachers", "\(String(SignedUser.id))", "apply-classroom")
        let body: [String : Any] = ["classroomId": id]
        
        NetworkManager.post(url: url, data: body, complete: {
            let alert = PGAlertPresentor(presentor: self)
            alert.present(title: "알림", context: "반 가입 요청을 보냈습니다!")
        })
    }
}

extension TeacherRequestClassroomJoinViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherClassroomCell") as! TeacherClassroomCell
        let classroomParse = viewModel.classrooms[indexPath.row].parse
        
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
                let alert = PGAlertPresentor(presentor: self)
                alert.present(title: "\(input)", context: "검색 결과가 없습니다.")
            }
            self.classroomTableView.reloadData()
        }
    }
    
    func networkFailAlert() {
        let alert = PGAlertPresentor(presentor: self)
        alert.presentNetworkError()
    }
}

class TeacherRequestClassroomJoinViewModel {
    var classrooms: [Classroom] = []
    var networkAlertDelegate: NetworkAlertDelegate?
    
    func searchClassroom(by input: String, complete: @escaping EmptyClosure) {
        var url: URL = NetworkManager.assembleURL("academy", "classrooms")
        url.appendQuery(queryItems: [URLQueryItem(name: "nameLike", value: input),
                                     URLQueryItem(name: "academyId", value: String((SignedUser.signedAcademy?.id)!))])
        
        let success: ResponseClosure = { data in
            guard let receivedClassrooms = try? data?.toObject(type: [Classroom].self) else {
                fatalError("TeacherRequestClassroomJoinViewModel.searchClassroom() -> data parse error")
            }
            self.classrooms = receivedClassrooms
        }
        
        let fail: FailClosure = {
            self.networkAlertDelegate?.networkFailAlert()
        }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
    }
    
    func getClassroomName(at index: Int) -> String {
        return classrooms[index].parse.classroomName
    }
    
    func getClassroomId(at index: Int) -> Int {
        return classrooms[index].id!
    }
}
