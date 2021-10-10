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

        self.setKeyboardDismissWatcher()
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
        PGSignedUser.applyClassroom(classroomId: id) { _ in
            let alert = PGAlertPresentor(presentor: self)
            alert.present(title: "알림", context: "반 가입 요청을 보냈습니다!")
        }
    }
}

extension TeacherRequestClassroomJoinViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassroomCell") as! ClassroomCell
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

extension TeacherRequestClassroomJoinViewController: UISearchBarDelegate {
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
}

class TeacherRequestClassroomJoinViewModel {
    var classrooms: [Classroom] = []
    
    func searchClassroom(by input: String, complete: @escaping (() -> Void)) {
        let url = PGURLs.classrooms.appendingQuery([URLQueryItem(name: "academyId", value: String(PGSignedUser.selectedAcademy.id!)),
                                                    URLQueryItem(name: "nameLike", value: input)])
        
        PGNetwork.get(url: url, type: [Classroom].self) { classrooms in
            self.classrooms = classrooms
            complete()
        }
    }
    
    func getClassroomName(at index: Int) -> String {
        return classrooms[index].parse.classroomName
    }
    
    func getClassroomId(at index: Int) -> Int {
        return classrooms[index].id!
    }
}
