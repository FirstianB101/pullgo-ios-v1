//
//  TeacherClassroomRemoveViewController.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/22.
//

import UIKit
import XLPagerTabStrip

class TeacherClassroomRemoveViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "삭제")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func removeClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "반을 삭제합니다.", message: "반 이름을 정확히 입력하면 삭제가 진행됩니다.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        let okay = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.removeClassroom()
        }
        
        alert.addTextField { field in
            field.placeholder = "삭제할 반 이름을 입력하세요."
            field.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
        }
        
        alert.addAction(cancel)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeClassroom() {        
        TeacherClassroomManageViewModel.selectedClassroom.delete(success: { _ in
            let alert = PGAlertPresentor()
            alert.present(title: "알림", context: "반이 삭제되었습니다.") { [weak self] _ in
                if let pvc = self?.presentingViewController as? TeacherClassroomManageViewController {
                    self?.dismiss(animated: true, completion: {
                        pvc.getClassroom()
                    })
                }
            }
        })
    }
    
    func isSameWithClassroomName(text: String?) -> Bool {
        guard let text = text else { return false }
        
        if text == TeacherClassroomManageViewModel.selectedClassroom.parse.classroomName {
            return true
        }
        return false
    }
}

extension UIAlertController {

    @objc func textDidChange() {
        let classroomName = TeacherClassroomManageViewModel.selectedClassroom!.parse.classroomName
        
        if let text = textFields?[0].text,
           let action = actions.last {
            action.isEnabled = (text == classroomName)
        }
    }
}
