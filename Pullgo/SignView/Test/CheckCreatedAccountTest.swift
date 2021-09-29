//
//  CheckCreatedAccountTest.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/09/29.
//

import XCTest
import Foundation
@testable import Pullgo

class CheckCreatedAccountTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTeacherParameter() throws {
        SignUpInformation.shared.userType = .teacher
        
        let info = SignUpInformation.shared
        info.account?.username = "xctest0"
        info.account?.password = "12345678"
        info.account?.fullName = "XCTEST"
        info.account?.phone = "01012345678"
        
        info.mergeAccount()
        
        let promise = XCTestExpectation(description: "POST Success")
            
        info.teacher?.post(success: { d in
        })
        
        wait(for: [promise], timeout: 10)
    }

    func testTeacherCreated() throws {
        let url = PGURLs.teachers
        
        let recentId = UserDefaults.standard.integer(forKey: "XCUITestCaseUsername")
        
        let promise = XCTestExpectation(description: "Teacher XC\(recentId) Exist")
        
        PGNetwork.get(url: url, type: [Teacher].self) { teachers in
            for teacher in teachers {
                if teacher.account.fullName == "XC\(recentId)" {
                    promise.fulfill()
                    return
                }
            }
        }
        
        wait(for: [promise], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
