//
//  SceneDelegate.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let autoLoginEnable = UserDefaults.standard.bool(forKey: plistKeys.AutoLoginKey.rawValue)
        
        print(autoLoginEnable)
        
        if !autoLoginEnable { return }
        else {
            guard let userType = UserType(rawValue: UserDefaults.standard.integer(forKey: plistKeys.userTypeKey.rawValue)) else { return }
            let userId = UserDefaults.standard.integer(forKey: plistKeys.userIdKey.rawValue)
            
            SignedUser.setUserInfo(id: userId, type: userType)
            
            let success: ResponseClosure = { data in
                var teacher: Teacher?
                var student: Student?
                
                if userType == .teacher {
                    teacher = try! data?.toObject(type: Teacher.self)
                    SignedUser.teacher = teacher
                    self.presentTeacherView()
                } else if userType == .student {
                    student = try! data?.toObject(type: Student.self)
                    SignedUser.student = student
                    self.presentStudentView()
                }
            }
            
            let fail: FailClosure = {
                self.presentSignInView()
            }
            
            SignedUser.requestSignIn(success: success, fail: fail)
        }
    }
    
    private func presentTeacherView() {
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeacherCalendarViewController") as! TeacherCalendarViewController
        
        present(vc)
    }
    
    private func presentStudentView() {
        
    }
    
    private func presentSignInView() {
        return
    }
    
    private func present(_ vc: UIViewController) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

