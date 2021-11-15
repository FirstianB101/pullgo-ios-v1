//
//  TestExamUI.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/11/12.
//

import XCTest

class TestExamUI: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    private func toCreateQuestionViewController(_ app: XCUIApplication) {
//
//        // 로그인
//        app.segmentedControls.buttons["선생님"].tap()
//        app.buttons["signIn"].tap()
//
//        // 반 관리 접속
//        app.navigationBars["수업 일정"].buttons["Item"].tap()
//        app.tables.staticTexts["반 관리"].tap()
//
//        // 반 클릭
//        tapTableView(app, title: TestType.createClassroom.rawValue + "1")
//
//        // 시험 클릭
//        tapCollectionView(app, title: TestType.createExam.rawValue + "14")
//
//        // 시험문제 수정 클릭
//        tapButton(app, title: "시험 문제 수정")
//    }

    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        
    }

}
