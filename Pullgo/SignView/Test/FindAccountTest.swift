//
//  FindAccountTest.swift
//  PullgoUITests
//
//  Created by 김세영 on 2021/07/08.
//

import XCTest

class FindAccountTest: XCTestCase {

    func testFindAccount() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["findAccount"].tap()
        
    }

}
