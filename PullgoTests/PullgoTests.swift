//
//  PullgoTests.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/06/27.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
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
    
    func testQuestionEqutable() throws {
        let lhs = Question()
        let rhs = Question()
        
        // lhs 값 설정
        lhs.questionNumber = 1
        lhs.content = "123"
        lhs.answer = [1, 2, 3]
        lhs.examId = 1
        lhs.choice = ["1" : "1", "2" : "2"]
        
        // rhs 값 설정
        rhs.questionNumber = 1
        rhs.content = "123"
        rhs.answer = [1, 2, 3]
        rhs.examId = 1
        rhs.choice = ["1" : "1", "2" : "2"]
        
        // lhs == rhs (같아야 함)
        XCTAssertEqual(lhs, rhs)
    }
    
    func testExamViewModel_isLastQuestion_isFirstQuestion() throws {
        
        let examViewModel = FakeQuestionViewModel()
        
        // currentQuestion을 첫 문제로 설정
        examViewModel.setCurrentQuestion(to: 1)
        // isFirstQuestion이 true여야 함
        XCTAssertTrue(examViewModel.isFirstQuestion)
        XCTAssertFalse(examViewModel.isLastQuestion)
        
        // currentQuestion을 마지막 문제로 설정
        examViewModel.setCurrentQuestion(to: 8)
        // isLastQuestion이 true여야 함
        XCTAssertTrue(examViewModel.isLastQuestion)
        XCTAssertFalse(examViewModel.isFirstQuestion)
    }
    
    func testCurrentQuestionObserver() throws {
        
        let examViewModel = FakeQuestionViewModel()
        let disposeBag = DisposeBag()
        let button = UIButton()
        
        let promise = XCTestExpectation(description: "Label Changed")
        
        examViewModel.currentQuestionSubject
            .bind(onNext: { question in
                print("######")
                print(question?.content)
                print("######")
                button.titleLabel?.text = String(question?.questionNumber ?? 0)
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        
        examViewModel.setCurrentQuestion(to: 3)
        wait(for: [promise], timeout: 10)
        
        XCTAssertEqual(button.titleLabel?.text, "3")
    }
}
