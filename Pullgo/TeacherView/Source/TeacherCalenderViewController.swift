//
//  TeacherCalenderViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/09.
//

import UIKit
import FSCalendar

class TeacherCalenderViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    let viewModel = TeacherCalenderViewModel()
    
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
}

// MARK: - Calendar Methods
extension TeacherCalenderViewController {
    
    func setCalendarUI() {
        calendar.locale = Locale(identifier: "ko_KR")
        setCalenderHeaderUI()
    }
    
    private func setCalenderHeaderUI() {
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

extension TeacherCalenderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        viewModel.getLessonsBetween(since: calendar.currentPage.firstDate, until: calendar.currentPage.nextMonth.firstDate)
    }
}

extension TeacherCalenderViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.getLessonsOf(date: date.toString()).count
    }
}

// MARK: - ViewModel
class TeacherCalenderViewModel {
    let teacher = SignedUserInfo.shared.teacher
    var lessonsOfMonth: [String : [Lesson]] = [:]
    
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
            
            lessonsOfMonth[date.toString()] = todayLessons
            date += Date.day
        }
    }
    
    func getLessonsOf(date: String) -> [Lesson] {
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

// MARK: - Date Extensions
extension Date {
    
    func toString(format: String = "YYYY-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func toKST() -> Date {
        let date = DateFormatter()
        
        date.locale = Locale(identifier: "ko_KR")
        date.timeZone = TimeZone(identifier: "ko_KR")
        date.dateFormat = "YYYY-MM-dd"

        let kst = date.string(from: self)
        return date.date(from: kst)!
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
}
