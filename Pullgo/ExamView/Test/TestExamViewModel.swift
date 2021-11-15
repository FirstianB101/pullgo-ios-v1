//
//  TestExamViewModel.swift
//  PullgoTests
//
//  Created by 김세영 on 2021/11/12.
//

import XCTest
@testable import Pullgo

class TestExamViewModel: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetTimeLimit() throws {
        let viewModel = CreateQuestionViewModel(exam: Exam())
        
        func convertTimeLimitToISO(hour: Int, minute: Int) -> Date {
            let formattedHour = String(hour).count == 1 ? "0\(hour)" : "\(hour)"
            let formattedMinute = String(minute).count == 1 ? "0\(minute)" : "\(minute)"
            
            let timeLimitString = "2021-1-1T\(formattedHour):\(formattedMinute):00"
            return timeLimitString.toISO8601
        }
        
        // Expect = PT2H30M
        var timeLimit = convertTimeLimitToISO(hour: 2, minute: 30)
        viewModel.setTimeLimit(timeLimit)
        XCTAssertEqual(viewModel.selectedExam.timeLimit!, "PT2H30M")
        
        // Expect = PT3H
        timeLimit = convertTimeLimitToISO(hour: 3, minute: 0)
        viewModel.setTimeLimit(timeLimit)
        XCTAssertEqual(viewModel.selectedExam.timeLimit!, "PT3H")
        
        // Expect = PT2M
        timeLimit = convertTimeLimitToISO(hour: 0, minute: 2)
        viewModel.setTimeLimit(timeLimit)
        XCTAssertEqual(viewModel.selectedExam.timeLimit!, "PT2M")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
