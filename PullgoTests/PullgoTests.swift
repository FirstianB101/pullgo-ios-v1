//
//  PullgoTests.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/06/27.
//

import XCTest
@testable import Pullgo

class PullgoTests: XCTestCase {

    func testSignUpUsernameStatus() {
        let vc = InputPasswordViewModel()
        
        vc.password = "123"
        vc.check = "123"
        
        XCTAssertEqual(vc.checkStatus, .correct)
    }
}
