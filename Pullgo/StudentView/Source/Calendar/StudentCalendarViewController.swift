//
//  StudentCalendarViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/13.
//

import UIKit
import SnapKit
import FSCalendar

class StudentCalendarViewController: UIViewController {
        
    lazy var noAcademyView = { () -> UIStackView in
        let stack = UIStackView()
        
        let noAcademyLabel = UILabel()
        noAcademyLabel.text = "가입된 학원이 없습니다."
        noAcademyLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        let join = UIButton()
        join.setTitle("학원 가입하기", for: .normal)
        join.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        join.addTarget(self, action: #selector(self.joinAcademy), for: .touchUpInside)
        
        stack.addArrangedSubview(noAcademyLabel)
        stack.addArrangedSubview(join)
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 65
        
        return stack
    }()
    
    @objc private func joinAcademy() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "StudentAcademyJoinRequestViewController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    let viewModel = StudentCalendarViewModel()
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getAcademies { [unowned self] isEmpty in
            if isEmpty {
                self.view.addSubview(self.noAcademyView)
                self.noAcademyView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.leading.trailing.equalToSuperview().offset(0)
                }
            } else {
                self.setCalendarUI()
                self.initializeCalendar()
            }
            self.calendar.isHidden = isEmpty
        }
    }
    
    private func initializeCalendar() {
        let since = calendar.currentPage.firstDate
        let until = since.nextMonth.firstDate
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        viewModel.getLessonsBetween(since: since, until: until) {
            self.calendar.reloadData()
        }
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        StudentViewSwitcher.showSideMenu(self)
    }
}

extension StudentCalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let storyboard = UIStoryboard(name: "Student", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "StudentCalendarSelectViewController") as? StudentCalendarSelectViewController else { return }
        
        self.view.alpha = 0.3
        
        detailVC.modalPresentationStyle = .custom
        detailVC.transitioningDelegate = self
        detailVC.view.layer.cornerRadius = 25
        detailVC.viewModel.selectedDate = date
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if viewModel.isLatestLessons(of: calendar.currentPage.yearAndMonth) { return }

        viewModel.getLessonsBetween(since: calendar.currentPage.firstDate, until: calendar.currentPage.nextMonth.firstDate) { [weak self] in
            self?.calendar.reloadData()
        }
    }
}

// MARK: - Calendar Methods
extension StudentCalendarViewController {
    
    func setCalendarUI() {
        calendar.locale = .current
        setCalendarHeaderUI()
    }
    
    private func setCalendarHeaderUI() {
        calendar.appearance.headerDateFormat = "M월 YYYY"
        setWeekendHeaderColorUI()
    }
    
    private func setWeekendHeaderColorUI() {
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        for i in 1...5 { calendar.calendarWeekdayView.weekdayLabels[i].textColor = .darkGray }
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue
    }
    
    @IBAction func gotoToday(_ sender: UIBarButtonItem) {
        calendar.select(Date(), scrollToDate: true)
    }
}

extension StudentCalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.getLessons(at: date).count
    }
}

extension StudentCalendarViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class StudentCalendarViewModel {
    
    private var isLatestLessonsOf = [YearAndMonth : Bool]()
    private var lessonsOfDate = [DateKey : [Lesson]]()
    
    public func getAcademies(completion: @escaping ((_ isEmpty: Bool) -> Void)) {
        PGSignedUser.getAcademies(page: 0) { academies in
            PGSignedUser.selectedAcademy = academies.first
            completion(academies.isEmpty)
        }
    }
    
    public func getLessons(at day: Date) -> [Lesson] {
        return lessonsOfDate[day.key] ?? []
    }
    
    public func getLessonsBetween(since: Date, until: Date, completion: @escaping (() -> Void)) {
        PGSignedUser.getLessons(since: since, until: until) { [weak self] lessons in
            self?.updateLatestInfo(since: since, until: until)
            self?.setLessons(lessons)
            completion()
        }
    }
    
    public func isLatestLessons(of date: YearAndMonth) -> Bool {
        return isLatestLessonsOf[date] ?? false
    }
    
    private func updateLatestInfo(since: Date, until: Date) {
        guard since < until else { return }
        
        var itrMonth = since
        
        while itrMonth < until {
            isLatestLessonsOf[itrMonth.yearAndMonth] = true
            itrMonth = itrMonth.nextMonth
        }
    }
    
    private func setLessons(_ lessons: [Lesson]) {
        for lesson in lessons {
            let lessonDate = lesson.schedule.date
            
            lessonsOfDate[lessonDate] = []
            lessonsOfDate[lessonDate]!.append(lesson)
        }
    }
}
