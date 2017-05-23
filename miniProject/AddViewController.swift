//
//  AddViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    let UserRef = Database.database().reference().child("User")
    var albumRef = Database.database().reference().child("Album")
    var imageView = UIImage()
    
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
            let alert = UIAlertController(title: "錯誤", message: "請先輸入開始日期", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.startDateTextField.becomeFirstResponder()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            inputDatePickerSet(textField: sender)
        }
    }
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        
        checkInputValue(name: nameTextField.text!, startDate: startDate!, endDate: endDate!, image: imageView)
        
        navigationController?.popViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            startDateTextField.becomeFirstResponder()
            return false
        } else if textField == startDateTextField {
            endDateTextField.becomeFirstResponder()
            return false
        } else if textField == endDateTextField {
            endDateTextField.resignFirstResponder()
            let alert = UIAlertController(title: "提醒", message: "請按下下面圖片來設定封面照片", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func inputDatePickerSet(textField: UITextField) {
        if textField.tag == 1 {
            startDateDataPicker.datePickerMode = .date
            startDateDataPicker.locale = NSLocale(localeIdentifier: "Chinese") as Locale
            
            setToolBar(textField: textField)
        } else if textField.tag == 2 {
            endDateDatePicker.datePickerMode = .date
            endDateDatePicker.locale = NSLocale(localeIdentifier: "Chinese") as Locale
            setToolBar(textField: textField)
        }
    }
    
    func checkInputValue(name:String, startDate:TimeInterval, endDate:TimeInterval, image:UIImage?) {
        if name == "" || startDateTextField.text == "" || endDateTextField.text == "" {
            let alert = UIAlertController(title: "錯誤", message: "輸入框請勿空白", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
           if image == nil {
            let alert = UIAlertController(title: "錯誤", message: "請設定封面相片", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("所有值都沒問題")
            saveTextField(name: name, startDate: startDate, endDate: endDate, image: image!)
                    }
        }
    }
    
   func saveTextField(name:String, startDate:TimeInterval, endDate:TimeInterval, image:UIImage) {
        let imageFilePath = "\(Auth.auth().currentUser?.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(image, 0.01)
        let metaData = StorageMetadata()
        Storage.storage().reference().child(imageFilePath).putData(data!, metadata: metaData) { (metadata, error) in
            if error != nil {
                return
            } else {
                let fileURL = metadata?.downloadURLs![0].absoluteString
                let newAlbum = self.albumRef.childByAutoId()
                let albumData = ["travelName": name, "startDate": startDate, "endDate":endDate, "image": fileURL!] as [String : Any]
                newAlbum.setValue(albumData)
            self.UserRef.child((Auth.auth().currentUser?.uid)!).setValue(["participateAlbum":newAlbum])
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
