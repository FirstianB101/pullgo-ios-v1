
//
//  TeacherUITest.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/07/09.
//

import XCTest
@testable import Pullgo

class TeacherUITest: XCTestCase {

    func testTeacherLogin() {
        
        let app = XCUIApplication()
        app.launch()
        
        let usernameField = app.textFields["loginUsername"]
        usernameField.tap()
        usernameField.typeText("swift")
        
        let passwordField = app.secureTextFields["loginPassword"]
        passwordField.tap()
        passwordField.typeText("12345678")
        
        app.buttons["signIn"].tap()
    }
    
    // MARK: - Test Help Methods
    enum TestType: String {
        case createLesson = "XCTestLesson"
        case createClassroom = "XCTestClassroom"
        case createExam = "XCTestExam"
        case createQuestion = "XCTestQuestion"
    }
    
    func getUniqueName(of type: TestType) -> String {
        let plist = UserDefaults.standard
        plist.synchronize()
        
        // Test 실행 시 id + 1로, 아이디 중복 생성 방지
        let id = plist.integer(forKey: type.rawValue)
        
        let newId = id + 1
        plist.setValue(newId, forKey: type.rawValue)
        
        return type.rawValue + String(newId)
    }
    
    func typeText(_ app: XCUIApplication, placeholder: String, text: String) {
        let textField = app.textFields[placeholder]
        textField.tap()
        textField.typeText(text)
        app.tap()
    }
    
    func tapButton(_ app: XCUIApplication, title: String) {
        let button = app.buttons[title]
        button.tap()
    }
    
    func tapTableView(_ app: XCUIApplication, title: String) {
        app.tables.staticTexts[title].tap()
    }
    
    func tapCollectionView(_ app: XCUIApplication, title: String) {
        app.collectionViews.staticTexts[title].tap()
    }
    
    func formattingDate(_ date: Date, to format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func datePicker(_ app: XCUIApplication, placeholder: String,
                    year: String,
                    month: String,
                    day: String) {
        app.textFields[placeholder].tap()
        
        let dateQuery = app.datePickers.pickerWheels
        
        dateQuery.element(boundBy: 0).adjust(toPickerWheelValue: year)
        dateQuery.element(boundBy: 1).adjust(toPickerWheelValue: month)
        dateQuery.element(boundBy: 2).adjust(toPickerWheelValue: day)
        app.toolbars["Toolbar"].buttons["완료"].tap()
    }
    
    func timePicker(_ app: XCUIApplication, placeholder: String,
                    hour: String,
                    minute: String) {
        app.textFields[placeholder].tap()
        
        let dateQuery = app.datePickers.pickerWheels
        
        dateQuery.element(boundBy: 0).adjust(toPickerWheelValue: "오후")
        dateQuery.element(boundBy: 1).adjust(toPickerWheelValue: hour)
        dateQuery.element(boundBy: 2).adjust(toPickerWheelValue: minute)
        app.toolbars["Toolbar"].buttons["완료"].tap()
    }
    
    // MARK: - 수업 생성 테스트
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
    
    // MARK: - 반 생성 테스트
    func testTeacherCreateClassroom() {
        
        let app = XCUIApplication()
        app.launch()
        
        // 로그인
        app.segmentedControls.buttons["선생님"].tap()
        app.buttons["signIn"].tap()
        
        // 반 관리 접속
        app.navigationBars["수업 일정"].buttons["Item"].tap()
        app.tables.staticTexts["반 관리"].tap()
        
        // 반 생성 버튼 클릭
        app.navigationBars["반 관리"].buttons["Add"].tap()

        // 반 이름 입력
        let textField = app.textFields["반 이름을 입력해주세요."]
        textField.tap()
        textField.typeText(getUniqueName(of: .createClassroom))
        app.tap()
        
        // 요일 선택
        app.staticTexts["월"].tap()
        app.staticTexts["수"].tap()
        app.staticTexts["금"].tap()
        
        // 학원 선택
        app.buttons["학원을 선택해주세요."].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"가발 제조 학원").element.tap()
        
        // 반 생성 버튼
        app.staticTexts["반 생성하기"].tap()
        app.alerts["PGAlert"].scrollViews.otherElements.buttons["확인"].tap()
    }
    
    // MARK: - 시험 생성 테스트
    func testCreateExam() {
        
        let app = XCUIApplication()
        app.launch()
        
        // 로그인
        app.segmentedControls.buttons["선생님"].tap()
        app.buttons["signIn"].tap()
        
        // 반 관리 접속
        app.navigationBars["수업 일정"].buttons["Item"].tap()
        app.tables.staticTexts["반 관리"].tap()
        
        // 반 클릭
        tapTableView(app, title: TestType.createClassroom.rawValue + "1")
        
        // 시험 추가 버튼 클릭
        app.navigationBars["시험 관리"].buttons["Add"].tap()
        
        // 시험 이름, 제한 시간 -> 분, 기준 점수 입력
        typeText(app, placeholder: "시험 이름을 입력해주세요.", text: getUniqueName(of: .createExam))
        typeText(app, placeholder: "시간", text: "2")
        typeText(app, placeholder: "분", text: "0")
        typeText(app, placeholder: "시험 통과 점수를 입력해주세요.", text: "80")
        
        // 다음으로 버튼 클릭
        tapButton(app, title: "다음으로  ")
        
        // 시작 날짜 선택
        tapButton(app, title: "시작 날짜를 선택해주세요.")
        
        // 날짜 선택 -> 시간 설정 -> 선택 완료
        typealias TestDateFormat = (year: String, month: String, day: String, hour: String, minute: String)
        
        func getDateAfter(days: Int) -> TestDateFormat {
            let date = Date().addingTimeInterval(TimeInterval(days * 60 * 60 * 24))
            var result: TestDateFormat
            
            result.year = formattingDate(date, to: "YYYY년")
            result.month = formattingDate(date, to: "M월")
            result.day = formattingDate(date, to: "d일")
            result.hour = formattingDate(date, to: "h")
            result.minute = String(Int(formattingDate(date, to: "m"))! / 5 * 5)
            
            result.minute = result.minute.count == 1 ? "0\(result.minute)" : result.minute
            
            return result
        }
        
        let start = getDateAfter(days: 5)
        datePicker(app, placeholder: "날짜를 선택해주세요.",
                   year: start.year, month: start.month, day: start.day)
        timePicker(app, placeholder: "시간을 선택해주세요.",
                   hour: start.hour, minute: start.minute)
        tapButton(app, title: "선택 완료")
        
        // 마감 날짜 선택
        tapButton(app, title: "마감 날짜를 선택해주세요.")
        
        // 날짜 선택 -> 시간 설정 -> 선택 완료
        let end = getDateAfter(days: 10)
        datePicker(app, placeholder: "날짜를 선택해주세요.",
                   year: end.year, month: end.month, day: end.day)
        timePicker(app, placeholder: "시간을 선택해주세요.",
                   hour: end.hour, minute: end.minute)
        tapButton(app, title: "선택 완료")
        
        // 시험 생성
        app.staticTexts["시험 생성"].tap()
    }
    
    func testQuestionViewUI_테스트() {
        
        let app = XCUIApplication()
        app.launch()
        
        // 로그인
        app.segmentedControls.buttons["선생님"].tap()
        app.buttons["signIn"].tap()
        
        // 반 관리 접속
        app.navigationBars["수업 일정"].buttons["Item"].tap()
        app.tables.staticTexts["반 관리"].tap()
        
        // 반 클릭
        tapTableView(app, title: TestType.createClassroom.rawValue + "1")
        
        // 시험 클릭
        tapCollectionView(app, title: TestType.createExam.rawValue + "14")
        
        // 시험문제 수정 클릭
        tapButton(app, title: "시험 문제 수정")
        
        // 다음 문제 클릭
        tapButton(app, title: "다음 문제")
        tapButton(app, title: "다음 문제")
        tapButton(app, title: "다음 문제")
        
        sleep(10)
    }
}
