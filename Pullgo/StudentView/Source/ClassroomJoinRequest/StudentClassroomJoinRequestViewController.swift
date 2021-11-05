//
//  StudentClassroomJoinRequestViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentClassroomJoinRequestViewController: UIViewController {
    
    let viewModel = StudentClassroomJoinRequestViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
}

extension StudentClassroomJoinRequestViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        viewModel.searchClassroom(by: query) { [unowned self] in
            if self.viewModel.getClassrooms().isEmpty {
                let alert = PGAlertPresentor()
                alert.present(title: "\(query)", context: "검색된 결과가 없어요.")
            }
            tableView.reloadData()
        }
    }
}

extension StudentClassroomJoinRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classroom = viewModel.getClassroom(at: indexPath.row)
        
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "요청", style: .default) { _ in
            PGSignedUser.applyClassroom(classroomId: classroom.id!) { _ in
                alert.present(title: "알림", context: "반 가입 요청을 보냈습니다.")
            }
        }
        
        alert.present(title: "알림",
                      context: "반 가입을 요청할까요?",
                      actions: [alert.cancel, okay])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getClassrooms().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClassroomCell") as? ClassroomCell else { return UITableViewCell() }
        
        let classroomInfo = viewModel.getClassroom(at: indexPath.row)
        
        cell.classroomNameLabel.text = classroomInfo.parse.classroomName
        cell.teacherNameLabel.text = classroomInfo.creator.account.fullName
        cell.weekdayLabel.text = classroomInfo.parse.weekday
        
        return cell
    }
}

class StudentClassroomJoinRequestViewModel {
    
    private var classrooms: [Classroom] = []
    private var page: Int = 0
    
    public func searchClassroom(by nameLike: String, completion: @escaping (() -> Void)) {
        let url = PGURLs.classrooms
            .appendingQuery([URLQueryItem(name: "nameLike", value: nameLike)])
            .pagination(page: page)
        
        PGNetwork.get(url: url, type: [Classroom].self) { classrooms in
            self.classrooms = classrooms
            completion()
        }
    }
    
    public func getClassrooms() -> [Classroom] {
        return self.classrooms
    }
    
    public func getClassroom(at index: Int) -> Classroom {
        return self.classrooms[index]
    }
}
