//
//  PullgoTests.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/06/27.
//

import XCTest
import Foundation
import RxSwift
import Alamofire
@testable import Pullgo

class PullgoTests: XCTestCase {
    
    func log(_ items: Any...) {
        print("###############################")
        print("PGTestLog: \(items)")
        print("###############################")
    }
    
    func testURL() throws {
        let string = "String".appending("asd")
        
        XCTAssertEqual(string, "Stringasd")
    }
    
    func testExample() throws {
        var urls = [URL]()
        for i in 1...4 {
            urls.append(PGURLs.teachers.appendingURL(["\(i)"]))
        }
        print(urls)
        
        let disposeBag = DisposeBag()
        let promise = XCTestExpectation(description: "Success")
        
        Observable.from(urls)
            .subscribe(onNext: { url in
                AF.request(url).response { response in
                    switch response.result {
                    case .success(let d):
                        print("log: ")
                        d?.log()
                        promise.fulfill()
                    case .failure(_):
                        print("fail")
                    }
                }
            }, onCompleted: {
                print("complete")
            }, onDisposed: {
                print("dispose")
            })
            .disposed(by: disposeBag)
        
        wait(for: [promise], timeout: 10)
    }
}
