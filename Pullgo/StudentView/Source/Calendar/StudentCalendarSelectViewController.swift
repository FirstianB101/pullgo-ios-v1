//
//  StudentCalendarSelectViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit

class StudentCalendarSelectViewController: UIViewController {
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var lessonList: UITableView!
    
    var initialCenter = CGPoint()
    let viewModel = StudentCalendarSelectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialCenter = CGPoint(x: view.center.x, y: view.bounds.height * (2 / 3))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedDateLabel.text = viewModel.selectedDate?.toString(format: "YYYY년 MM월 dd일")
        viewModel.getLessons { [weak self] in
            self?.lessonList.reloadData()
        }
    }
}

extension StudentCalendarSelectViewController: UITableViewDelegate {
    
}

extension StudentCalendarSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLessons().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LessonListCell") as? LessonListCell else { return UITableViewCell() }
        
        let lesson = viewModel.getLesson(at: indexPath.row)
        
        lesson.getBelongedAcademy{ academy in
            cell.academyLabel.text = academy.name
        }
        cell.lessonNameLabel.text = lesson.name
        cell.timeLabel.text = lesson.getTime()
        
        return cell
    }
}

class StudentCalendarSelectViewModel {
    
    var selectedDate: Date!
    private var lessons: [Lesson] = []
    private var page: Int = 0
    
    public func getLessons(completion: @escaping (() -> Void)) {
        PGSignedUser.getLessons(since: selectedDate, until: selectedDate.tommorow, page: page) { lessons in
            self.lessons = lessons
            completion()
        }
    }
    
    public func getLessons() -> [Lesson] {
        return self.lessons
    }
    
    public func getLesson(at index: Int) -> Lesson {
        return lessons[index]
    }
}

// MARK: - Pan Gesture Control
extension StudentCalendarSelectViewController {
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
