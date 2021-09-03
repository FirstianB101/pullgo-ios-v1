//
//  PGTextField.swift
//  Pullgo
//
//  Created by 김세영 on 2021/08/31.
//

import UIKit

protocol PGDatePickerDelegate {
    func datePicker(_ inputView: PGTextField, selected: Date)
}

@IBDesignable
public class PGTextField: UITextField, Styler {
    
    var toolbarDelegate: PGDatePickerDelegate?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)!
        setStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    init() {
        super.init(frame: .zero)
        setStyle()
    }
    
    private func setStyle() {
        setTextFieldBorderUnderline(field: self)
    }
    
    public func useTextFieldByDatePicker(picker: UIDatePicker) {
        let toolbar = PGToolbar(datePicker: picker, inputView: self)
        
        self.inputAccessoryView = toolbar
        self.inputView = picker
    }
}

fileprivate class PGToolbar: UIToolbar {
    var datePicker: UIDatePicker?
    var textField: PGTextField?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setToolbar()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setToolbar()
    }
    
    init(datePicker: UIDatePicker, inputView: PGTextField) {
        let height = 35
        self.datePicker = datePicker
        self.textField = inputView
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        setToolbar()
    }
    
    private func setToolbar() {
        setToolbarColor()
        setToolbarItem()
    }
    
    private func setToolbarColor() {
        self.barTintColor = .lightGray
        self.tintColor = .black
    }
    
    private func setToolbarItem() {
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(donePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setItems([space, done], animated: true)
    }
    
    @objc func donePicker() {
        guard let textField = self.textField, let picker = self.datePicker else { return }
        
        textField.toolbarDelegate?.datePicker(textField, selected: picker.date)
        textField.endEditing(true)
    }
}
