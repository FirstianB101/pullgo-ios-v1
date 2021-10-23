//
//  TeacherClassroomChangeInfoViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/22.
//

import UIKit
import XLPagerTabStrip

class TeacherClassroomChangeInfoViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet var weekdayButtons: [UIButton]!
    @IBOutlet weak var classroomNameField: PGTextField!
    
    let viewModel = TeacherClassroomChangeInfoViewModel()

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수정")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeekdayButtonID()
        setButtonUI()
        initializeUI()
        self.setKeyboardDismissWatcher()
    }
    
    private func initializeUI() {
        weekdayButtons.forEach { button in
            toggleButtonUI(of: button)
        }
        
        classroomNameField.text = viewModel.getDefaultClassroomName()
    }
    
    func setWeekdayButtonID() {
        let weekday: [Weekday] = Weekday.allCases
        for i in 0 ..< weekday.count {
            weekdayButtons[i].setTitle(weekday[i].rawValue, for: .normal)
        }
    }
    
    func setButtonUI() {
        setWeekdayButtonCircle()
    }
    
    func setWeekdayButtonCircle() {
        weekdayButtons.forEach { $0.setViewCornerRadius() }
    }
    
    @IBAction func weekdayButtonClicked(_ sender: UIButton) {
        guard let weekday = sender.titleLabel?.text else { return }
        viewModel.toggleWeekdaySelected(weekday)
        toggleButtonUI(of: sender)
    }
    
    func toggleButtonUI(of button: UIButton) {
        let color: UIColor = viewModel.isWeekdaySelected(day: button.titleLabel!.text!) ? UIColor(named: "LightAccent")! : .white
        UIView.animate(withDuration: 0.2, animations: {
            button.backgroundColor = color
        })
    }
    
    func setClassroomName() {
        guard let name = classroomNameField.text else { return }
        self.viewModel.setClassroomName(name)
    }
    
    @IBAction func changeButtonClicked(_ sender: PGButton) {
        setClassroomName()
        
        let alert = PGAlertPresentor()
        let okay = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.viewModel.changeInfo { _ in
                alert.present(title: "알림", context: "반 정보 수정이 완료되었습니다.") { _ in
                    if let pvc = self?.presentingViewController as? TeacherClassroomManageViewController {
                        pvc.getClassroom()
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        alert.present(title: "알림", context: "입력하신 정보로 반을 수정합니다.", actions: [alert.cancel, okay])
    }
    
    @IBAction func ignoreSemiColons(_ sender: UITextField) {
        if sender.text?.last == ";" {
            
            sender.vibrate()
            sender.text?.removeLast()
        }
    }
}

class TeacherClassroomChangeInfoViewModel {
    
    private var selectedWeekday = [String : Bool]()
    private var selectedClassroom = TeacherClassroomManageViewModel.selectedClassroom
    private var newClassroomName = ""
    
    init() {
        Weekday.allCases.forEach { weekday in
            selectedWeekday[weekday.rawValue] = false
        }
        setDefaultWeekdays()
        newClassroomName = getDefaultClassroomName()
    }
    
    private func setDefaultWeekdays() {
        let weekday = selectedClassroom!.parse.weekday
        weekday.map { String($0) }.forEach { weekday in
            if let _ = Weekday.init(rawValue: weekday) {
                selectedWeekday[weekday] = true
            }
        }
    }
    
    public func setClassroomName(_ name: String) {
        self.newClassroomName = name
    }
    
    public func getDefaultClassroomName() -> String {
        return selectedClassroom!.parse.classroomName
    }
    
    public func toggleWeekdaySelected(_ weekday: String) {
        selectedWeekday[weekday] = !selectedWeekday[weekday]!
    }
    
    public func isWeekdaySelected(day: String) -> Bool {
        return selectedWeekday[day]!
    }
    
    public func getSelectedWeekdays() -> String {
        var result = ""
        Weekday.allCases.forEach { weekday in
            if selectedWeekday[weekday.rawValue]! {
                result.append(weekday.rawValue)
            }
        }
        return result
    }
    
    public func changeInfo(completion: @escaping ((Data?) -> Void)) {
        let parse = selectedClassroom!.name.split(separator: ";")
        let teacherName = String(parse[1])
        let weekdays = getSelectedWeekdays()
        
        selectedClassroom?.setInformation(classroomName: newClassroomName, teacherName: teacherName, weekdays: weekdays)
        print(selectedClassroom!.parse)
        selectedClassroom?.patch(success: completion)
    }
}
