//
//  TeacherCreateClassroomViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/30.
//

import UIKit
import Alamofire

protocol TeacherCreateClassroomSelectAcademyDelegate {
    func setSelectedAcademy(academy: Academy)
}

enum Weekday: String, CaseIterable {
    case sunday = "일"
    case monday = "월"
    case tuesday = "화"
    case wednesday = "수"
    case thursday = "목"
    case friday = "금"
    case saturday = "토"
}

class TeacherCreateClassroomViewController: UIViewController {

    @IBOutlet weak var classroomNameField: PGTextField!
    @IBOutlet weak var classroomCreateButton: PGButton!
    @IBOutlet weak var academySelectButton: UIButton!
    @IBOutlet var weekdayButtons: [UIButton]!
    let viewModel = TeacherCreateClassroomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonUI()
        setWeekdayButtonID()
        self.setKeyboardDismissWatcher()
    }
    
    func setWeekdayButtonID() {
        let weekday: [Weekday] = Weekday.allCases
        for i in 0 ..< weekday.count {
            weekdayButtons[i].setTitle(weekday[i].rawValue, for: .normal)
        }
    }
    
    func setButtonUI() {
        academySelectButton.setViewCornerRadiusAndShadow(radius: 25)
        setWeekdayButtonCircle()
    }
    
    func setWeekdayButtonCircle() {
        weekdayButtons.forEach { $0.setViewCornerRadius() }
    }
    
    @IBAction func ignoreSemiColons(_ sender: UITextField) {
        if sender.text?.last == ";" {
            
            sender.vibrate()
            sender.text?.removeLast()
        }
    }
    
    @IBAction func createClassroomClicked(_ sender: UIButton) {
        guard let classroomName = classroomNameField.text else { return }
        viewModel.updateClassroomName(name: classroomName)
        
        if !isClassroomInformationEmpty() {
            viewModel.createClassroom() { _ in
                self.classroomCreateCompleteAlert()
            }
        }
    }
    
    func isClassroomInformationEmpty() -> Bool {
        if viewModel.classroomName.isEmpty {
            classroomNameEmptyAlert()
            return true
        } else if !viewModel.isAcademySelected() {
            academyNotSelectedAlert()
            return true
        }
        return false
    }
    
    private func classroomNameEmptyAlert() {
        let alert = PGAlertPresentor(presentor: self)
        alert.present(title: "알림", context: "반 이름을 입력해주세요.")
    }
    
    
    private func academyNotSelectedAlert() {
        let alert = PGAlertPresentor(presentor: self)
        alert.present(title: "알림", context: "학원을 선택해주세요.")
    }
    
    private func classroomCreateCompleteAlert() {
        let alert = PGAlertPresentor(presentor: self)
        alert.present(title: viewModel.classroomName, context: "반이 생성되었습니다.") { action in
            self.reloadPresentingVCData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func reloadPresentingVCData() {
        let pvc = self.presentingViewController as! TeacherClassroomManageViewController
        
        pvc.getClassroom()
    }
    
    @IBAction func weekdayButtonsClicked(_ sender: UIButton) {
        guard let weekday = sender.titleLabel?.text else { return }
        viewModel.toggleWeekdaySelect(day: weekday)
        toggleButtonUI(of: sender)
    }
    
    func toggleButtonUI(of button: UIButton) {
        let color: UIColor = viewModel.isWeekdaySelected(day: button.titleLabel!.text!) ? UIColor(named: "LightAccent")! : .white
        UIView.animate(withDuration: 0.2, animations: {
            button.backgroundColor = color
        })
    }
}

extension TeacherCreateClassroomViewController: TeacherCreateClassroomSelectAcademyDelegate {
    func setSelectedAcademy(academy: Academy) {
        viewModel.updateSelectedAcademy(academy: academy)
        updateSelectedAcademyButton()
    }
    
    func updateSelectedAcademyButton() {
        academySelectButton.backgroundColor = UIColor(named: "SelectedColor")
        academySelectButton.setTitle(viewModel.selectedAcademy?.name, for: .normal)
        academySelectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    @IBAction func selectAcademyClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherCreateClassroomSelectAcademyViewController") as! TeacherCreateClassroomSelectAcademyViewController
        
        vc.viewModel.selectAcademyDelegate = self
        vc.navigationController?.navigationItem.title = "학원 선택"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class TeacherCreateClassroomViewModel {
    var classroomName = ""
    var selectedAcademy: Academy?
    var selectedWeekdays: [String : Bool] = [:]
    
    init() {
        Weekday.allCases.forEach { day in
            selectedWeekdays[day.rawValue] = false
        }
    }
    
    func updateClassroomName(name: String) {
        self.classroomName = name
    }
    
    func updateSelectedAcademy(academy: Academy) {
        self.selectedAcademy = academy
    }
    
    func isAcademySelected() -> Bool {
        if selectedAcademy == nil { return false }
        return true
    }
    
    func createClassroom(success: @escaping ((Data?) -> Void)) {
        let classroom = Classroom()
        
        classroom.name = self.formattingClassroomName()
        classroom.academyId = self.selectedAcademy?.id
        classroom.creator = PGSignedUser.teacher!
        
        classroom.post(success: success)
    }
    
    func formattingClassroomName() -> String {
        var formattedClassroomName: String = ""
        appendClassroomName(&formattedClassroomName)
        appendTeacherFullName(&formattedClassroomName)
        appendSelectedWeekday(&formattedClassroomName)
        
        return formattedClassroomName
    }
    
    private func appendClassroomName(_ classroomName: inout String) {
        classroomName += self.classroomName
        appendSeparator(&classroomName)
    }
    
    private func appendTeacherFullName(_ classroomName: inout String) {
        classroomName += PGSignedUser.teacher.account.fullName
        appendSeparator(&classroomName)
    }
    
    private func appendSelectedWeekday(_ classroomName: inout String) {
        Weekday.allCases.forEach { day in
            guard let isDaySelected = self.selectedWeekdays[day.rawValue] else { return }
            if isDaySelected {
                classroomName += day.rawValue
            }
        }
    }
    
    private func appendSeparator(_ classroomName: inout String) {
        let separator = ";"
        classroomName += separator
    }
    
    func toggleWeekdaySelect(day: String) {
        selectedWeekdays[day] = !selectedWeekdays[day]!
    }
    
    func isWeekdaySelected(day: String) -> Bool {
        return selectedWeekdays[day]!
    }
}
