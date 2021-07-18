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
        let date = DateFormatter().string(from: Date())
        
        XCTAssertEqual(date, "")
    }
}
