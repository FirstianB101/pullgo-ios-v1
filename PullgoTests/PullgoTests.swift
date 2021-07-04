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
        let account: Account = Account(username: "harry", password: "123", fullName: "김세영", phone: "01075230867")
        var body: Data?
        
        do {
            body = try JSONEncoder().encode(account)
        } catch {
            print("fail")
        }
        
        var test: Account = Account()
        do {
            test = try JSONDecoder().decode(Account.self, from: body!)
        } catch {
            print("fail")
        }
        
        XCTAssertEqual(account.username, test.username)
        XCTAssertEqual(account.password, test.password)
        XCTAssertEqual(account.fullName, test.fullName)
        XCTAssertEqual(account.phone, test.phone)
    }
}
