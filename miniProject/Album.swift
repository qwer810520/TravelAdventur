//
//  Album.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
import UIKit
class Album {
    var key:String
    var travelName: String
    var startDate: Double
    var endDate: Double
    var titleImage: String
    var photos:Array<PhotoDataModel>
    
    init(key:String, travelName:String, startDate:Double, endDate:Double, titleImage:String, photos:Array<PhotoDataModel>) {
        self.key = key
        self.travelName = travelName
        self.startDate = startDate
        self.endDate = endDate
        self.titleImage = titleImage
        self.photos = photos
    }
}


extension AddViewController {
    func setToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        if textField.tag == 1 {
            let checkButton = UIBarButtonItem(title: "check", style: .plain, target: self, action: #selector(startDateCheckButtonSet))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(startDateCancelButtonSet))
            
            toolBar.setItems([cancelButton, spaceButton, checkButton], animated: true)
            toolBar.isUserInteractionEnabled = true
            
            startDateTextField.inputView = startDateDataPicker
            startDateTextField.inputAccessoryView = toolBar
        } else if textField.tag == 2 {
            let checkButton = UIBarButtonItem(title: "check", style: .plain, target: self, action: #selector(endDateCheckButtonSet))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endDateCancelButtonSet))
            
            toolBar.setItems([cancelButton, spaceButton, checkButton], animated: true)
            toolBar.isUserInteractionEnabled = true
            
            endDateTextField.inputView = endDateDatePicker
            endDateTextField.inputAccessoryView = toolBar
        }
    }
    
    func startDateCheckButtonSet() {
        startDateTextField.text = Library.dateToShowString(date: startDateDataPicker.date.timeIntervalSince1970)
        endDateDatePicker.minimumDate = startDateDataPicker.date
        startDate = startDateDataPicker.date.timeIntervalSince1970
        endDateTextField.becomeFirstResponder()
    }
    
    func startDateCancelButtonSet() {
        startDateTextField.resignFirstResponder()
    }
    
    func endDateCheckButtonSet() {
        endDateTextField.text = Library.dateToShowString(date: endDateDatePicker.date.timeIntervalSince1970)
        endDate = endDateDatePicker.date.timeIntervalSince1970
        endDateTextField.resignFirstResponder()
    }
    
    func endDateCancelButtonSet() {
        endDateTextField.resignFirstResponder()
    }
}

