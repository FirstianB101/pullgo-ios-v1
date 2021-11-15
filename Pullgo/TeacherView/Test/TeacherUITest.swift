
//
//  TeacherUITest.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/07/09.
//

import XCTest

class TeacherUITest: XCTestCase, PGTestCase {

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
    
    // MARK: - 학원 생성 테스트
    func testCreateAcademy() {
        
        let app = XCUIApplication()
        app.launch()
        
        // 로그인
        app.segmentedControls.buttons["선생님"].tap()
        app.buttons["signIn"].tap()
        
        // 학원 생성 접속
        app.navigationBars["수업 일정"].buttons["Item"].tap()
        app.buttons["학원 생성하기"].tap()
        
        // 이름 및 전화번호 입력
        typeText(app, placeholder: "학원 이름을 입력해주세요.", text: getUniqueName(of: .createAcademy))
        typeText(app, placeholder: "전화번호를 입력해주세요. (- 제외)", text: "01012345678")
        
        // 다음으로
        tapButton(app, title: "다음으로")
        
        // 도로명 주소 및 상세주소 입력
        typeText(app, placeholder: "서울특별시 중구 세종대로 1200", text: "서울특별시 광운로 2나길 45")
        typeText(app, placeholder: "광운빌딩 608호", text: getUniqueName(of: .firstian))
        
        // 학원 생성하기
        tapButton(app, title: "학원 생성")
        
        // 알림 제거 및 메인화면 복귀
        tapAlert(app, title: "알림", button: "확인")
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
        textField.typeText(getUniqueName(of: TestType.createClassroom))
        app.tap()
        
        // 요일 선택
        app.staticTexts["월"].tap()
        app.staticTexts["수"].tap()
        app.staticTexts["금"].tap()
        
        // 학원 선택
        app.buttons["학원을 선택해주세요."].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"정상수의 랩 레슨").element.tap()
        
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
        // TEST FORM ->   title: TestType.createClassroom.rawValue + "테스트용 반 번호"
        tapTableView(app, title: TestType.createClassroom.rawValue + "3")
        
        // 시험 추가 버튼 클릭
        app.navigationBars["시험 관리"].buttons["Add"].tap()
        
        // 시험 이름, 제한 시간 -> 분, 기준 점수 입력
        let examName = getUniqueName(of: .createExam)
        typeText(app, placeholder: "시험 이름을 입력해주세요.", text: examName)
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
        
        // 예
        tapAlert(app, title: "\(examName)", button: "예")
        
        // 문제 추가
        tapButton(app, title: "Add") // 2
        tapButton(app, title: "Add") // 3
        
        // Exam Navigator
        tapButton(app, title: "3")
        tapButton(app, title: "1") // 1번 문제로 이동
        
        // 보기 작성 및 완료
        tapButton(app, title: "보기 작성")
        tapButton(app, title: "완료")
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
        tapTableView(app, title: TestType.createClassroom.rawValue + "3")
        
        // 시험 클릭
        tapCollectionView(app, title: TestType.createExam.rawValue + "20")
        
        // 시험문제 수정 클릭
        tapButton(app, title: "시험 문제 수정")
        
        // 다음 문제 클릭
        tapButton(app, title: "다음 문제")
        tapButton(app, title: "다음 문제")
        tapButton(app, title: "다음 문제")
        
        sleep(10)
    }
}
