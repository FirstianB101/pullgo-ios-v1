//
//  PGTestCase.swift
//  PGTestCase
//
//  Created by 김세영 on 2021/11/12.
//

import UIKit
import XCTest

public enum TestType: String {
    case firstian = "퍼스티안 B"
    case createAcademy = "XCTestAcademy"
    case createLesson = "XCTestLesson"
    case createClassroom = "XCTestClassroom"
    case createExam = "XCTestExam"
    case createQuestion = "XCTestQuestion"
}

protocol PGTestCase { } 

extension PGTestCase {
    
    // MARK: - Test Help Methods
    
    func getUniqueName(of type: TestType) -> String {
        let plist = UserDefaults.standard
        plist.synchronize()
        
        // Test 실행 시 id + 1로, 아이디 중복 생성 방지
        let id = plist.integer(forKey: type.rawValue)
        
        let newId = id + 1
        plist.setValue(newId, forKey: type.rawValue)
        
        return type.rawValue + String(newId)
    }
    
    func typeText(_ app: XCUIApplication, placeholder: String, text: String) {
        let textField = app.textFields[placeholder]
        textField.tap()
        textField.typeText(text)
        app.tap()
    }
    
    func tapButton(_ app: XCUIApplication, title: String) {
        let button = app.buttons[title]
        button.tap()
    }
    
    func tapTableView(_ app: XCUIApplication, title: String) {
        app.tables.staticTexts[title].tap()
    }
    
    func tapCollectionView(_ app: XCUIApplication, title: String) {
        app.collectionViews.staticTexts[title].tap()
    }
    
    func formattingDate(_ date: Date, to format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func datePicker(_ app: XCUIApplication, placeholder: String,
                         year: String,
                         month: String,
                         day: String) {
        app.textFields[placeholder].tap()
        
        let dateQuery = app.datePickers.pickerWheels
        
        dateQuery.element(boundBy: 0).adjust(toPickerWheelValue: year)
        dateQuery.element(boundBy: 1).adjust(toPickerWheelValue: month)
        dateQuery.element(boundBy: 2).adjust(toPickerWheelValue: day)
        app.toolbars["Toolbar"].buttons["완료"].tap()
    }
    
    func timePicker(_ app: XCUIApplication, placeholder: String,
                         hour: String,
                         minute: String) {
        app.textFields[placeholder].tap()
        
        let dateQuery = app.datePickers.pickerWheels
        
        dateQuery.element(boundBy: 0).adjust(toPickerWheelValue: "오후")
        dateQuery.element(boundBy: 1).adjust(toPickerWheelValue: hour)
        dateQuery.element(boundBy: 2).adjust(toPickerWheelValue: minute)
        app.toolbars["Toolbar"].buttons["완료"].tap()
    }
    
    func tapAlert(_ app: XCUIApplication, title: String, button: String) {
        let alert = app.alerts[title]
        let button = alert.buttons[button]
        button.tap()
    }
}
