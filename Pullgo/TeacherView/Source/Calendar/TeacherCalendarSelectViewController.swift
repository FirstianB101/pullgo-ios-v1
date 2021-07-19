//
//  TeacherCalendarSelectViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/14.
//

import UIKit

class TeacherCalendarSelectViewController: UIViewController, Styler {

    var initialCenter = CGPoint()
    @IBOutlet weak var lessonList: UITableView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var createLessonButton: UIButton!
    weak var delegate: TeacherCalendarSelectDelegate?
    let viewModel = TeacherCalendarSelectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
        setViewCornerRadius(view: createLessonButton)
        setViewShadow(view: createLessonButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewModel.delegate = self.delegate
        viewModel.setLessons()
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
        viewModel.setLessons()
        lessonList.reloadData()
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
        cell.academyLabel.text = viewModel.getBelongAcademyName(at: indexPath.row)
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
        let animator = AnimationPresentor()
        let pvc = self.presentingViewController!
        dismiss(animated: true) {
            animator.gettingBright(view: pvc.view)
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
    var selectedDate: Date {
        get {
            return delegate?.selectedDate?.toKST() ?? Date()
        }
    }
    weak var delegate: TeacherCalendarSelectDelegate?
    
    func setLessons() {
        guard let lessons = delegate?.getLessonsOf(date: self.selectedDate) else { return }
        
        self.lessons = lessons
    }
    
    func getLessonTime(at: Int) -> String {
        guard let schedule = lessons[at].schedule else { return "" }
        var message: String = cutSecondsInTime(time: schedule.beginTime)
        message += " ~ "
        message += cutSecondsInTime(time: schedule.endTime)
        
        return message
    }
    
    func getBelongAcademyName(at: Int) -> String {
        guard let academy = lessons[at].belongAcademy else { return "" }
        return academy.name!
    }
    
    private func cutSecondsInTime(time: String) -> String {
        let times = time.split(separator: ":")
        return "\(times[0]):\(times[1])"
    }
}
