//
//  TeacherViewSwitcher.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/15.
//

import Foundation
import UIKit
import SideMenu

enum TeacherMenu: String, CaseIterable {
    case calendarView = "수업 일정"
    case classroomManage = "반 관리"
    case requestClassroomJoin = "반 가입 요청"
    case changeInfo = "회원정보 수정"
    case applyAcademyJoinRequest = "학원 가입 승인"
    case academyManage = "학원 관리"
    
    static func index(of value: TeacherMenu) -> Int {
        switch value {
        case .calendarView:
            return 0
        case .classroomManage:
            return 1
        case .requestClassroomJoin:
            return 2
        case .changeInfo:
            return 3
        case .applyAcademyJoinRequest:
            return 4
        case .academyManage:
            return 5
        }
    }
    
    func identifierOfViewContoller() -> String {
        switch self {
        case .calendarView:
            return "TeacherCalendarViewController"
        case .classroomManage:
            return "TeacherClassroomManageViewController"
        case .requestClassroomJoin:
            return "TeacherRequestClassroomJoinViewController"
        case .changeInfo:
            return "TeacherChangeInfoViewController"
        case .applyAcademyJoinRequest:
            return "TeacherApplyAcademyJoinRequestViewController"
        case .academyManage:
            return "TeacherAcademyManageViewController"
        }
    }
}

class TeacherViewSwitcher {
    static func switchView(_ presentor: UIViewController, presenting: TeacherMenu) {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        guard let pvc = presentor.presentingViewController else { return }
        let vc = storyboard.instantiateViewController(withIdentifier: presenting.identifierOfViewContoller())
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        presentor.dismiss(animated: true, completion: {
            pvc.present(vc, animated: false, completion: nil)
        })
    }
    
    /// Called when menu button clicked
    /// rootViewController: always self
    static func showSideMenu(_ rootViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherMenuViewController") as! TeacherMenuViewController
        let menu = SideMenuNavigationController(rootViewController: vc)
        
        menu.presentationStyle = CustomSideMenuStyle()
        menu.leftSide = true
        menu.menuWidth = rootViewController.view.bounds.width * (4 / 5)
        
        rootViewController.present(menu, animated: true, completion: nil)
    }
}
