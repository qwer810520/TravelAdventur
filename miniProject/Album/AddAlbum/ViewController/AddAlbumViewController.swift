//
//  AddViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class AddAlbunViewController: ParentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView = UIImage()
    
    private var addAlbum = AddAlbumModel()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBAction func inputImageBotton(_ sender: UIButton) {
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startDateBegin(_ sender: UITextField) {
        inputDatePickerSet(textField: sender)
    }
    
    @IBAction func endDateBegin(_ sender: UITextField) {
        if startDateTextField.text == "" {
            present(Library.alertSet(title: "錯誤", message: "請先輸入開始日期", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: { (_) in
                self.startDateTextField.becomeFirstResponder()
            }), animated: true, completion: nil)
        } else {
            inputDatePickerSet(textField: sender)
        }
    }
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        checkInputValue(name: nameTextField.text!, startDate: startDate!, endDate: endDate!, image: imageView)
    }
    
    var startDateDataPicker = UIDatePicker()
    var endDateDatePicker = UIDatePicker()
    var startDate:TimeInterval?
    var endDate:TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style:.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.center = view.center
        self.backgroundImage.addSubview(blurEffectView)
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func inputDatePickerSet(textField: UITextField) {
        if textField.tag == 1 {
            startDateDataPicker.datePickerMode = .date
            startDateDataPicker.locale = NSLocale(localeIdentifier: "Chinese") as Locale
//            setToolBar(textField: textField)
        } else if textField.tag == 2 {
            endDateDatePicker.datePickerMode = .date
            endDateDatePicker.locale = NSLocale(localeIdentifier: "Chinese") as Locale
//            setToolBar(textField: textField)
        }
    }
    
    func checkInputValue(name:String, startDate:TimeInterval, endDate:TimeInterval, image:UIImage?) {
        
        if name == "" || startDateTextField.text == "" || endDateTextField.text == "" {
            present(Library.alertSet(title: "錯誤", message: "輸入框請勿空白", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        } else {
            if image == nil {
                present(Library.alertSet(title: "錯誤", message: "請設定封面相片", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
            } else {
//                SVProgressHUD.show(withStatus: "新增中...")
                FirebaseManager.shared.saveAlbumDataToFirebase(name: name, startDate: startDate, endDate: endDate, image: image!, completion: {
//                    SVProgressHUD.dismiss()
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
                        NotificationCenter.default.post(name: Notification.Name("updata"), object: nil, userInfo: ["switch": "Album"])
                        self.navigationController?.popViewController(animated: true)
                    })
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            buttonImage.image = picture
            backgroundImage.image = picture
            buttonImage.clipsToBounds = true
            imageView = picture
            
        }
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - UITextFieldDelegate

extension AddAlbunViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            startDateTextField.becomeFirstResponder()
            return false
        case startDateTextField:
            endDateTextField.becomeFirstResponder()
            return false
        case endDateTextField:
            endDateTextField.resignFirstResponder()
            return false
        default:
            return true
        }
    }
}

/*
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
    
    @objc func startDateCheckButtonSet() {
        startDateTextField.text = Library.dateToShowString(date: startDateDataPicker.date.timeIntervalSince1970)
        endDateDatePicker.minimumDate = startDateDataPicker.date
        startDate = startDateDataPicker.date.timeIntervalSince1970
        endDateTextField.becomeFirstResponder()
    }
    
    @objc func startDateCancelButtonSet() {
        startDateTextField.resignFirstResponder()
    }
    
    @objc func endDateCheckButtonSet() {
        endDateTextField.text = Library.dateToShowString(date: endDateDatePicker.date.timeIntervalSince1970)
        endDate = endDateDatePicker.date.timeIntervalSince1970
        endDateTextField.resignFirstResponder()
    }
    
    @objc func endDateCancelButtonSet() {
        endDateTextField.resignFirstResponder()
    }
}
*/
