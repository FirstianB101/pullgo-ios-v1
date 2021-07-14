//
//  PullgoTests.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/06/27.
//

import XCTest
@testable import Pullgo

class PullgoTests: XCTestCase {
    
    func testExample() throws {
        var date = Date()
        
        XCTAssertEqual((date + 24 * 3600).toString(), "2021-07-14")
    }
}
