//
//  TextFieldExtension.swift
//  iosbingo
//
//  Created by Hamza Saeed on 04/09/2022.
//

import UIKit
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
	
	
	func setInputViewDatePicker(target: Any, selector: Selector) {
		let screenWidth = UIScreen.main.bounds.width
		let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
		datePicker.datePickerMode = .date
		if #available(iOS 14, *) {
			datePicker.preferredDatePickerStyle = .wheels
			datePicker.sizeToFit()
		}
		self.inputView = datePicker
		let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
		let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
		let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
		toolBar.setItems([cancel, flexible, barButton], animated: false) //8
		self.inputAccessoryView = toolBar //9
	}
	
	@objc func tapCancel() {
		self.resignFirstResponder()
	}
	
}
