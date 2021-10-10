//
//  TeacherCalendarSelectViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/14.
//

import UIKit

class TeacherCalendarSelectViewController: UIViewController {

    @IBOutlet weak var lessonList: UITableView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var createLessonButton: UIButton!
    
    var initialCenter = CGPoint()
    let viewModel = TeacherCalendarSelectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
        createLessonButton.setViewCornerRadiusAndShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        reloadTableView()
        setTableViewUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let pvc = self.presentingViewController! as! TeacherCalendarViewController
        pvc.calendar.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! UINavigationController
        let createLessonVC = nvc.viewControllers.first as! TeacherCreateLessonViewController
        createLessonVC.viewModel.selectedDate = viewModel.selectedDate
    }
    
    func setTableViewUI() {
        selectedDate.text = viewModel.selectedDate.toString(format: "YYYY년 M월 d일")
    }
    
    @IBAction func createLesson(_ sender: UIButton) {
        performSegue(withIdentifier: "TeacherCreateLessonSegue", sender: nil)
    }
    
    func reloadTableView() {
        viewModel.getLessons() {
            self.lessonList.reloadData()
        }
    }
}

extension TeacherCalendarSelectViewController: UITableViewDelegate {
    
}

extension TeacherCalendarSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonListCell", for: indexPath) as! LessonListCell
        viewModel.getBelongAcademyName(at: indexPath.row) { academyName in
            cell.academyLabel.text = academyName
        }
        cell.lessonNameLabel.text = viewModel.lessons[indexPath.row].name
        cell.timeLabel.text = viewModel.getLessonTime(at: indexPath.row)
        
        return cell
    }
}

// MARK: - Pan Gesture Control
extension TeacherCalendarSelectViewController {
    @IBAction func panSlide(_ sender: UIPanGestureRecognizer) {
            
        if self.view.center.y > self.view.bounds.height * 1.2 && sender.state == .ended {
            dismissView()
            return
        }
        
        if sender.state == .began || sender.state == .changed {
            if self.view.center.y >= initialCenter.y {
                let transition = sender.translation(in: self.view)
                let moveY = self.view.center.y + transition.y
                
                if self.view.center.y == initialCenter.y {
                    if moveY < 0 { return }
                }
                
                self.view.center = CGPoint(x: initialCenter.x, y: moveY)
                
            }
            sender.setTranslation(.zero, in: self.view)
        }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.center = self.initialCenter
            })
        }
    }
    
    @IBAction func panDown(_ sender: UIButton) {
        self.dismissView()
    }
    
    func dismissView() {
        let pvc = self.presentingViewController!
        dismiss(animated: true) {
            pvc.view.gettingBright()
        }
    }
}

class LessonListCell: UITableViewCell {
    @IBOutlet weak var academyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lessonNameLabel: UILabel!
}

class TeacherCalendarSelectViewModel {
    
    var lessons: [Lesson] = []
    var selectedDate: Date!
    
    public func getLessons(completion: (() -> Void)? = nil) {
        let url = PGURLs.lessons.appendingQuery([URLQueryItem(name: "teacherId", value: String(PGSignedUser.teacher.id!)),
                                                 URLQueryItem(name: "sinceDate", value: selectedDate.toString()),
                                                 URLQueryItem(name: "untilDate", value: selectedDate.tommorow.toString())])
        
        PGNetwork.get(url: url, type: [Lesson].self) { lessons in
            self.lessons = lessons
            completion?()
        }
    }
    
    func getLessonTime(at: Int) -> String {
        return self.lessons[at].getTime()
    }
    
    func getBelongAcademyName(at: Int, completion: @escaping ((String) -> Void)) {
        let lesson = self.lessons[at]
        lesson.getBelongedAcademy { academy in
            completion(academy.name)
        }
    }
    
    private func cutSecondsInTime(time: String) -> String {
        let times = time.split(separator: ":")
        return "\(times[0]):\(times[1])"
    }
}
