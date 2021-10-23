//
//  TeacherCalendarViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/09.
//

import UIKit
import FSCalendar
import SideMenu
import SnapKit

class TeacherCalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var noAcademyStack: UIStackView!
    let viewModel = TeacherCalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PGSignedUser.getAcademies(page: 0) { academies in
            if academies.isEmpty {
                self.presentNoAcademy()
            } else {
                PGSignedUser.selectedAcademy = academies[0]
                
                self.setCalendarUI()
                self.initializeCalendar()
            }
        }
    }
    
    public func reloadData() {
        initializeCalendar()
    }
    
    private func presentNoAcademy() {
        self.calendar.isHidden = true
        self.noAcademyStack.isHidden = false
    }
    
    @objc private func joinAcademy() {
        // 학원 가입 뷰로 전환
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
        TeacherViewSwitcher.showSideMenu(self)
    }
}

// MARK: - Calendar Methods
extension TeacherCalendarViewController {
    
    func setCalendarUI() {
        self.noAcademyStack.isHidden = true
        self.calendar.isHidden = false
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

extension TeacherCalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "TeacherCalendarSelectViewController") as? TeacherCalendarSelectViewController else { return }
        
        self.view.alpha = 0.3
        
        detailVC.modalPresentationStyle = .custom
        detailVC.transitioningDelegate = self
        detailVC.view.layer.cornerRadius = 25
        detailVC.viewModel.selectedDate = date
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if viewModel.isLastestDataOfMonth(date: calendar.currentPage.yearAndMonth) { return }
        
        viewModel.getLessonsBetween(since: calendar.currentPage.firstDate, until: calendar.currentPage.nextMonth.firstDate) {
            self.calendar.reloadData()
        }
    }
}

extension TeacherCalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.getLessonsOf(date: date.toString()).count
    }
}

// MARK: - Half Modal
extension TeacherCalendarViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - ViewModel
class TeacherCalendarViewModel {
    var lessonsOfMonth: [DateKey : [Lesson]] = [:]
    private let lessonsSize: Int = 100
    private var _isLastestDataOfMonth: [YearAndMonth : Bool] = [:]
    
    public func getLessonsBetween(since: Date, until: Date, complete: (() -> Void)? = nil) {
        let url = PGURLs.lessons.appendingQuery([URLQueryItem(name: "teacherId", value: String(PGSignedUser.teacher.id!)),
                                                 URLQueryItem(name: "sinceDate", value: since.toString()),
                                                 URLQueryItem(name: "untilDate", value: until.toString())])
            .pagination(page: 0, size: self.lessonsSize)
        
        PGNetwork.get(url: url, type: [Lesson].self) { lessons in
            self.setLessonsByReceivedData(since: since, until: until, lessons: lessons)
            complete?()
        }
    }
    
    private func setLessonsByReceivedData(since: Date, until: Date, lessons: [Lesson]) {
        var date = since
        
        while date < until {
            var todayLessons: [Lesson] = []
            for lesson in lessons {
                if date.toString() == lesson.schedule!.date {
                    todayLessons.append(lesson)
                }
            }
            
            lessonsOfMonth[date.key] = todayLessons
            date += Date.day
        }
    }
    
    private func updateLastestDataOfMonth(date: YearAndMonth) {
        _isLastestDataOfMonth[date] = true
    }
    
    func isLastestDataOfMonth(date: YearAndMonth) -> Bool {
        guard let status = _isLastestDataOfMonth[date] else {
            return false
        }
        if !status { return false }
        else { return true }
    }
    
    func getLessonsOf(date: DateKey) -> [Lesson] {
        return lessonsOfMonth[date] ?? []
    }
}
