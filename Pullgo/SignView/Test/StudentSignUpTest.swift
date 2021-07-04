//
//  StudentSignUpTest.swift
//  PullgoUITests
//
//  Created by 김세영 on 2021/07/05.
//

import XCTest

class StudentSignUpTest: XCTestCase {

    func testStudentSignUp() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["signUpButton"].tap()
        app.buttons["loginStudent"].tap()
        
        let idField = app.textFields["inputUsername"]
        idField.tap()
        idField.typeText("11111a")
        
        app.buttons["duplicateCheck"].tap()
        app.buttons["next"].tap()
        
        let passwordField = app.secureTextFields["inputPassword"]
        passwordField.tap()
        passwordField.typeText("123456789")
        
        let passwordCheckField = app.secureTextFields["checkPassword"]
        passwordCheckField.tap()
        passwordCheckField.typeText("123456789")
        app.buttons["next"].tap()
        
        let phoneField = app.textFields["inputPhone"]
        phoneField.tap()
        phoneField.typeText("01012345678")
        app.buttons["verifyButton"].tap()
        
        let verifyField = app.textFields["inputVerifyNumber"]
        verifyField.tap()
        verifyField.typeText("1111")
        app.buttons["next"].tap()
    }

}
