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
        let account = Account(username: "yy0867", password: "123456", fullName: "김세영", phone: "01012345678")
        let teacher = Teacher(id: nil, account: account)
        let url = NetworkManager.assembleURL(components: ["teachers"])
        
        NetworkManager.post(url: url, data: teacher)
    }
}
