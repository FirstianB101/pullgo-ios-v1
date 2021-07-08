//
//  TeacherSignUpTest.swift
//  PullgoUITests
//
//  Created by 김세영 on 2021/07/05.
//

import XCTest

class TeacherSignUpTest: XCTestCase {
    
    func testTeacherSignUp() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["signUpButton"].tap()
        app.buttons["loginTeacher"].tap()
        
        let idField = app.textFields["inputUsername"]
        idField.tap()
        idField.typeText("testid")
        
        app.buttons["duplicateCheck"].tap()
        app.buttons["next"].tap()
        
        let passwordField = app.secureTextFields["inputPassword"]
        passwordField.tap()
        passwordField.typeText("123456789")
        
        let passwordCheckField = app.secureTextFields["checkPassword"]
        passwordCheckField.tap()
        passwordCheckField.typeText("123456789")
        app.buttons["next"].tap()
        
        let fullNameField = app.textFields["inputFullName"]
        fullNameField.tap()
        fullNameField.typeText("test fullname")
        
        let phoneField = app.textFields["inputPhone"]
        phoneField.tap()
        phoneField.typeText("01012345678")
        app.buttons["verifyButton"].tap()
        
        let verifyField = app.textFields["inputVerifyNumber"]
        verifyField.tap()
        verifyField.typeText("1111")
        app.buttons["next"].tap()
        
        app.alerts["알림"].scrollViews.otherElements.buttons["확인"].tap()
    }
}
