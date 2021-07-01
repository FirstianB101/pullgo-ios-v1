//
//  Extension.swift
//  Pullgo
//
//  Created by 김세영 on 2021/07/01.
//

import Foundation

extension String {
    func predicate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
