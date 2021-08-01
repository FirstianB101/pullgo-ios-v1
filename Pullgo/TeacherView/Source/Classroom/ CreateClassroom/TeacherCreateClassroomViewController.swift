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

class TeacherCreateClassroomViewController: UIViewController, Styler, NetworkAlertDelegate {
    func networkFailAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.presentNetworkError()
    }
    

    @IBOutlet weak var classroomNameField: UITextField!
    @IBOutlet weak var classroomCreateButton: UIButton!
    @IBOutlet weak var academySelectButton: UIButton!
    @IBOutlet var weekdayButtons: [UIButton]!
    let viewModel = TeacherCreateClassroomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setWeekdayButtonID()
        setDismissKeyboardEnable()
        viewModel.networkFailDelegate = self
    }
    
    func setWeekdayButtonID() {
        let weekday: [Weekday] = Weekday.allCases
        for i in 0 ..< weekday.count {
            weekdayButtons[i].setTitle(weekday[i].rawValue, for: .normal)
        }
    }
    
    func setUI() {
        setTextFieldBorderUnderline(field: classroomNameField)
        setButtonUI()
        setWeekdayButtonCircle()
    }
    
    func setButtonUI() {
        setViewCornerRadius(view: classroomCreateButton)
        setViewShadow(view: classroomCreateButton)
        setViewCornerRadius(view: academySelectButton, radius: 25)
        setViewShadow(view: academySelectButton)
    }
    
    func setWeekdayButtonCircle() {
        weekdayButtons.forEach { setViewCornerRadius(view: $0) }
    }
    
    @IBAction func createClassroomClicked(_ sender: UIButton) {
        guard let classroomName = classroomNameField.text else { return }
        viewModel.updateClassroomName(name: classroomName)
        
        if !isClassroomInformationEmpty() {
            viewModel.sendCreateClassroomRequest() {
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
        let alert = AlertPresentor(presentor: self)
        alert.present(title: "알림", context: "반 이름을 입력해주세요.")
    }
    
    
    private func academyNotSelectedAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.present(title: "알림", context: "학원을 선택해주세요.")
    }
    
    private func classroomCreateCompleteAlert() {
        let alert = AlertPresentor(presentor: self)
        alert.present(title: viewModel.classroomName, context: "반이 생성되었습니다.")
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class TeacherCreateClassroomViewModel {
    var classroomName = ""
    var selectedAcademy: Academy?
    var networkFailDelegate: NetworkAlertDelegate?
    var selectedWeekdays: [String : Bool] = [:]
    
    init() {
        Weekday.allCases.forEach { d in
            print(d.rawValue)
            selectedWeekdays[d.rawValue] = false
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
    
    func sendCreateClassroomRequest(complete: @escaping EmptyClosure) {
        let url = NetworkManager.assembleURL("academy", "classrooms")
        let classroomBody = createClassroomBody()
        let fail: FailClosure = {
            self.networkFailDelegate?.networkFailAlert()
        }
        
        NetworkManager.post(url: url, data: classroomBody, fail: fail, complete: complete)
    }
    
    func createClassroomBody() -> Parameters {
        guard let selectedAcademy = selectedAcademy else {
            fatalError("TeacherCreateClassroomViewModel.createClassroomBody() -> selected academy unwrap fail")
        }
        
        let formattedClassroomName = formattingClassroomName()
        let body: Parameters = ["name" : formattedClassroomName,
                                "academyId" : selectedAcademy.id!,
                                "creatorId": SignedUser.id!]
        return body
    }
    
    func formattingClassroomName() -> String {
        return ""
    }
    
    func toggleWeekdaySelect(day: String) {
        selectedWeekdays[day] = !selectedWeekdays[day]!
    }
    
    func isWeekdaySelected(day: String) -> Bool {
        return selectedWeekdays[day]!
    }
}
