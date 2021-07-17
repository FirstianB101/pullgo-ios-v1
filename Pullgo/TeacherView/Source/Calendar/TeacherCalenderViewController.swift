//
//  TeacherCalendarViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/09.
//

import UIKit
import FSCalendar
import SideMenu

protocol TeacherCalendarSelectDelegate: AnyObject {
    var selectedDate: Date? { get }
    func getLessonsOf(date: Date) -> [Lesson]
}

class TeacherCalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    let viewModel = TeacherCalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarUI()
        viewModel.view = self
        self.calendar.dataSource = self
        self.calendar.delegate = self
        initializeCalendar()
    }
    
    func initializeCalendar() {
        let since = calendar.currentPage.firstDate.toKST()
        let until = since.nextMonth.firstDate.toKST()
        
        viewModel.getLessonsBetween(since: since, until: until) {
            self.calendar.reloadData()
        }
    }
    
    @IBAction func showSideMenu(_ sender: UIBarButtonItem) {
        TeacherViewSwitcher.showSideMenu(self)
    }
}

extension TeacherCalendarViewController: TeacherCalendarSelectDelegate {
    var selectedDate: Date? {
        return calendar.selectedDate
    }
    
    func getLessonsOf(date: Date) -> [Lesson] {
        return viewModel.getLessonsOf(date: date.key)
    }
}

// MARK: - Calendar Methods
extension TeacherCalendarViewController {
    
    func setCalendarUI() {
        calendar.locale = Locale(identifier: "ko_KR")
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
        calendar.select(Date().toKST(), scrollToDate: true)
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
        detailVC.delegate = self
        
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let view = containerView else { return CGRect.zero }
            let inset: CGFloat = 0
            
            return CGRect(x: inset, y: view.bounds.height * (1 / 3), width: view.bounds.width - (inset * 2), height: view.bounds.height * (2 / 3))
        }
    }
}


// MARK: - ViewModel
class TeacherCalendarViewModel {
    let teacher = SignedUser.teacher
    private var _isLastestDataOfMonth: [YearAndMonth : Bool] = [:]
    var lessonsOfMonth: [DateKey : [Lesson]] = [:]
    var view: UIViewController! = nil
    
    func getLessonsBetween(since: Date, until: Date, complete: (() -> ())? = nil) {
        var url: URL = NetworkManager.assembleURL(components: ["academy", "classroom", "lessons"])
        
        url.appendQuery(queryItems: assembleQueries(since: since, until: until))
        
        let success: ((Data?) -> ()) = { data in
            guard let receivedLessons = try? data?.toObject(type: [Lesson].self) else {
                print("TeacherCalendarViewModel.getLessonsBetween() -> error in success -> receivedLesson = ...")
                return
            }
            self.setLessonsByReceivedData(since: since, until: until, lessons: receivedLessons)
            self.updateLastestDataOfMonth(date: since.yearAndMonth)
        }
        
        let fail: (() -> ()) = {
            let alert = AlertPresentor(view: self.view)
            alert.presentNetworkError()
        }
        
        NetworkManager.get(url: url, success: success, fail: fail, complete: complete)
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
    
    private func assembleQueries(since: Date, until: Date) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        items.append(URLQueryItem(name: "teacherId", value: String((self.teacher?.id!)!)))
        items.append(URLQueryItem(name: "sinceDate", value: since.toKST().toString()))
        items.append(URLQueryItem(name: "untilDate", value: until.toKST().toString()))
        
        return items
    }
}

/// The type of key in the dictionary that uses the "YYYY-MM" format for key
typealias YearAndMonth = String

/// The type of key in the dictionary that uses the "YYYY-MM-dd" format for key.
typealias DateKey = String

// MARK: - Date Extensions
extension Date {
    
    func toString(format: String = "YYYY-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func toKST() -> Date {
        return self.addingTimeInterval(9 * 3600)
    }
    
    var nextMonth: Date {
        get {
            return self + 40 * Date.day
        }
    }
    
    static var day: TimeInterval {
        get {
            return 24 * 60 * 60
        }
    }
    
    var firstDate: Date {
        get {
            let day = Double(self.toString(format: "dd"))! - 2
            
            return self - Date.day * day
        }
    }
    
    var key: String {
        return self.toString()
    }
    
    var yearAndMonth: YearAndMonth {
        return self.toString(format: "YYYY-MM")
    }
}
