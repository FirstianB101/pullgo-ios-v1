//
//  TeacherUITest.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/07/09.
//

import XCTest

class TeacherUITest: XCTestCase {

    func testTeacherLogin() {
        
        let app = XCUIApplication()
        app.launch()
        
        let usernameField = app.textFields["loginUsername"]
        usernameField.tap()
        usernameField.typeText("2")
        
        let passwordField = app.secureTextFields["loginPassword"]
        passwordField.tap()
        passwordField.typeText("123123")
        
        app.buttons["signIn"].tap()
    }
    
    func testTeacherCreateLesson() {
        
        let app = XCUIApplication()
        app.launch()
        
        app.segmentedControls.buttons["선생님"].tap()
        
        let usernameField = app.textFields["loginUsername"]
        usernameField.tap()
        usernameField.typeText("2")
        
        let passwordField = app.secureTextFields["loginPassword"]
        passwordField.tap()
        passwordField.typeText("123123")
        
        app.buttons["signIn"].tap()
                
    }
}
