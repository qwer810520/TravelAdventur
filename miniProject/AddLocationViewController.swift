//
//  AddLocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMaps
import GooglePlaces


class AddLocationViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBAction func dateTextField(_ sender: UITextField) {
        selectDateSet(textField: sender)
    }
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        checkInputTextAndUpdata(location: locationTextField.text!, day: dayTextField.text!)
        navigationController?.popViewController(animated: true)
        
    }
    
    let selectDatePickerView = UIDatePicker()
    var selectDate:TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        dayTextField.delegate = self
        
        locationTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            dayTextField.becomeFirstResponder()
            return false
        } else if textField == dayTextField {
            dayTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func selectDateSet(textField:UITextField) {
        selectDatePickerView.datePickerMode = .date
        selectDatePickerView.locale = NSLocale(localeIdentifier: "Chinese") as Locale
        selectDatePickerView.minimumDate = Date(timeIntervalSince1970: FirebaseServer.firebase().getSelectAlbumData().startDate)
        selectDatePickerView.maximumDate = Date(timeIntervalSince1970: FirebaseServer.firebase().getSelectAlbumData().endDate)
        toolBarSet(textField: textField)
        
    }
    
    func toolBarSet(textField:UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let checkButton = UIBarButtonItem(title: "Check", style: .plain, target: self,  action: #selector(checkButtonSet))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonSet))
        toolBar.setItems([cancelButton, spaceButton, checkButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        dayTextField.inputView = selectDatePickerView
        dayTextField.inputAccessoryView = toolBar
    }
    
    func checkButtonSet() {
        dayTextField.text = Library.dateToShowString(date: selectDatePickerView.date.timeIntervalSince1970)
        selectDate = selectDatePickerView.date.timeIntervalSince1970
        dayTextField.resignFirstResponder()
    }
    
    func cancelButtonSet() {
        dayTextField.resignFirstResponder()
    }
    
    
    func checkInputTextAndUpdata(location:String, day:String) {
        if location == "" || day == "" {
            present(Library.alertSet(title: "錯誤", message: "輸入框不能為空", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        } else {
          
        }
    }
}
