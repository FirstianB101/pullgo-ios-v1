//
//  StudentViewSwitcher.swift
//  Pullgo
//
//  Created by 김세영 on 2021/10/09.
//

import UIKit
import SideMenu

enum StudentMenu: String, CaseIterable {
    case calendarView = "수업 일정"
    case examList = "시험 목록"
    case examHistory = "오답노트"
    case classroomJoinRequest = "반 가입 요청"
    case changeInfo = "회원정보 수정"
    case manageSendRequest = "보낸 요청 관리"
    
    static func value(at index: Int) -> StudentMenu {
        switch index {
        case 0:
            return .calendarView
        case 1:
            return .examList
        case 2:
            return .examHistory
        case 3:
            return .classroomJoinRequest
        case 4:
            return .changeInfo
        case 5:
            return .manageSendRequest
        default:
            return .calendarView
        }
    }
    
    func identifierOfViewContoller() -> String {
        switch self {
        case .calendarView:
            return "StudentCalendarViewController"
        case .examList:
            return "StudentExamListViewController"
        case .examHistory:
            return "StudentExamHistoryViewController"
        case .classroomJoinRequest:
            return "StudentClassroomJoinRequestViewController"
        case .changeInfo:
            return "StudentChangeInfoViewController"
        case .manageSendRequest:
            return "StudentManageSendRequestViewController"
        }
    }
}

class StudentViewSwitcher {
    static func switchView(_ presentor: UIViewController, presenting: StudentMenu) {
        let storyboard = UIStoryboard(name: "Student", bundle: nil)
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
        let storyboard = UIStoryboard(name: "Student", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentSideMenuViewController") as! TeacherMenuViewController
        let menu = SideMenuNavigationController(rootViewController: vc)
        
        menu.presentationStyle = CustomSideMenuStyle()
        menu.leftSide = true
        menu.menuWidth = rootViewController.view.bounds.width * (4 / 5)
        
        rootViewController.present(menu, animated: true, completion: nil)
    }
}
