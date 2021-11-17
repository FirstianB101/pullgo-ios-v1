//
//  StudentSignUpTest.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/09/22.
//

import XCTest
import Foundation

class StudentSignUpTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testCreateStudent() {
        let app = XCUIApplication()
        app.launch()
        
        func tapButton(_ id: String) {
            app.buttons[id].tap()
        }
        
        func typeTextField(_ id: String, text: String) {
            let field = app.textFields[id]
            field.tap()
            field.typeText(text)
        }
        
        func tapAlert(_ actionIndex: Int) {
            let action = app.alerts["PGAlert"].buttons[String(actionIndex)]
            action.tap()
        }
        
        // Test 실행 시 id + 1로, 아이디 중복 생성 방지
        let plist = UserDefaults.standard
        let id = plist.integer(forKey: "student")
        
        let newId = id + 1
        plist.setValue(newId, forKey: "student")
        
        struct PGTestAccount {
            var username: String
            var password: String = "12345678"
            var fullName: String
            var phone: String = "01075230867"
            var schoolName: String = "퍼스티안학교"
            var schoolYear: Int = 2
            var parentPhone: String = "01012345678"
        }
        
        let account = PGTestAccount(username: "student\(newId)", fullName: "XCTest\(newId)")
        
        // 회원가입 -> 선생님으로 로그인
        tapButton("signUpButton")
        tapButton("loginStudent")
        
        // 아이디 입력
        typeTextField("inputUsername", text: account.username)
        
        // 중복확인 -> 다음으로
        tapButton("duplicateCheck")
        tapButton("next")
        
        // 비밀번호, 확인, 다음으로
        let passwordField = app.secureTextFields["inputPassword"]
        passwordField.tap()
        passwordField.typeText(account.password)
        
        let passwordCheckField = app.secureTextFields["checkPassword"]
        passwordCheckField.tap()
        passwordCheckField.typeText(account.password)
        
        tapButton("next")
        
        // 이름, 전화번호, 인증 요청, 인증번호 -> 다음으로
        typeTextField("inputFullName", text: account.fullName)
        typeTextField("inputPhone", text: account.phone)
        tapButton("verifyButton")
        typeTextField("inputVerifyNumber", text: "1111")
        tapButton("next")
        
        // 부모님 전화번호, 학교 이름, 학년 -> 회원가입
        typeTextField("inputParentPhone", text: account.parentPhone)
        typeTextField("inputSchoolName", text: account.schoolName)
        app.segmentedControls["inputSchoolYear"].buttons["\(account.schoolYear)학년"].tap()
        app.tap()
        tapButton("next")
        
        tapAlert(1)
        tapAlert(0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
