//
//  TeacherCreateClassroomViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/30.
//

import UIKit

protocol TeacherCreateClassroomSelectAcademyDelegate {
    func setSelectedAcademy(academy: Academy)
}

class TeacherCreateClassroomViewController: UIViewController, Styler {

    @IBOutlet weak var classroomNameField: UITextField!
    @IBOutlet weak var classroomCreateButton: UIButton!
    @IBOutlet weak var academySelectButton: UIButton!
    let viewModel = TeacherCreateClassroomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setDismissKeyboardEnable()
    }
    
    func setUI() {
        setTextFieldBorderUnderline(field: classroomNameField)
        setViewCornerRadius(view: classroomCreateButton)
        setViewShadow(view: classroomCreateButton)
        setViewCornerRadius(view: academySelectButton, radius: 25)
        setViewShadow(view: academySelectButton)
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
    
    func sendCreateClassroomRequest(complete: EmptyClosure) {
        var url = NetworkManager.assembleURL("")
    }
}
