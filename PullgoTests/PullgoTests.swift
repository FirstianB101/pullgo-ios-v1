//
//  PullgoTests.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/06/27.
//

import XCTest
import Foundation
import Alamofire
@testable import Pullgo

class PullgoTests: XCTestCase {
    
    func log(_ items: Any...) {
        print("###############################")
        print("PGTestLog: \(items)")
        print("###############################")
    }
    
    func testExample() throws {
        let url = PGURLs.teachers
        
        var data: Data?
        
        let promise = XCTestExpectation(description: "GET teachers success")
        AF.request(url).response { response in
            switch response.result {
            case .success(let d):
                data = d
                promise.fulfill()
            case .failure(_):
                print("error")
            }
        }
        wait(for: [promise], timeout: 10)
        
        guard let received = data else { return }
        print(String(data: received, encoding: .utf8))
        
        let decoder = JSONDecoder()
        let teachers = try! decoder.decode([Teacher].self, from: received)
        
        print(teachers)
    }
}
