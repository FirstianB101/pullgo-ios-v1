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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectAcademyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.isEnabled = false
        setAcademyButtonData()
        
        self.setKeyboardDismissWatcher()
    }
    
    private func setAcademyButtonData() {
        var elements: [UIMenuElement] = []
        
        let `default` = UIAction(title: "학원을 선택해주세요.") { [weak self] _ in
            self?.viewModel.selectedAcademy = nil
            self?.searchBar.searchTextField.isEnabled = false
            self?.reloadData()
        }
        elements.append(`default`)
        
        for academy in PGSignedUser.academies {
            let element = UIAction(title: academy.name) { [weak self] _ in
                self?.viewModel.selectedAcademy = academy
                self?.searchBar.searchTextField.isEnabled = true
                self?.reloadData()
            }
            elements.append(element)
        }
        
        selectAcademyButton.menu = UIMenu(title: "학원을 선택해주세요.", options: .displayInline, children: elements)
    }
    
    private func reloadData() {
        viewModel.classrooms = []
        self.classroomTableView.reloadData()
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
        let classroom = viewModel.classrooms[indexPath.row]
        
        cell.teacherNameLabel.text = classroom.creator.account.fullName
        cell.weekdayLabel.text = classroom.parse.weekday
        cell.classroomNameLabel.text = classroom.parse.classroomName
        
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
    var selectedAcademy: Academy!
    
    func searchClassroom(by input: String, complete: @escaping (() -> Void)) {
        let url = PGURLs.classrooms.appendingQuery([URLQueryItem(name: "academyId", value: String(self.selectedAcademy.id!)),
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
