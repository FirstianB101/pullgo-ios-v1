//
//  Extension.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import UIKit
import ObjectiveC

extension String {
    var toISO8601: Date {
        get {
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: self + "+0900") else { return Date() }
            return date
        }
    }
    
    func predicate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

/// The type of key in the dictionary that uses the "YYYY-MM" format for key
typealias YearAndMonth = String

/// The type of key in the dictionary that uses the "YYYY-MM-dd" format for key.
typealias DateKey = String

// MARK: - Date Extensions
extension Date {
    
    /// base format = "YYYY-MM-dd"
    func toString(format: String = "YYYY-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    static var day: TimeInterval {
        return 24 * 60 * 60
    }
    
    var nextMonth: Date {
        self + 40 * Date.day
    }
    
    var tommorow: Date {
        self + Date.day
    }
    var firstDate: Date {
        let day = Double(self.toString(format: "dd"))! - 1
        
        return self - Date.day * day
    }
    
    var isToday: Bool {
        return self.toString() == Date().toString()
    }
    
    var key: String {
        return self.toString()
    }
    
    var yearAndMonth: YearAndMonth {
        return self.toString(format: "YYYY-MM")
    }
}

extension UIViewController {
    
    public func checkAllFieldValid(fields: [UITextField]) -> Bool {
        for field in fields {
            if let text = field.text {
                if text.isEmpty {
                    field.vibrate()
                    return false
                }
            } else {
                field.vibrate()
                return false
            }
        }
        
        return true
    }
}

extension UITextView {
    
    public func addDismissToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let dismiss = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard(_:)))
        
        toolbar.setItems([.flexibleSpace(), dismiss], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc
    func dismissKeyboard(_ sender: UITextView) {
        self.endEditing(true)
    }
}
