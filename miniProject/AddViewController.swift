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
    
    var albumRef = FIRDatabase.database().reference().child("Album")
    var imageView = UIImage()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func inputImageBotton(_ sender: UIButton) {
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        
        checkInputValue(name: nameTextField.text!, year: yearTextField.text!, month: monthTextField.text!, day: dayTextField.text!, date: dateTextField.text!, image: imageView)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style:.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.center = view.center
        self.backgroundImage.addSubview(blurEffectView)
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        dateTextField.delegate = self
        yearTextField.delegate = self
        monthTextField.delegate = self
        dayTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        let alert = UIAlertController(title: "請輸入", message: "1.行程名稱\n 2.旅遊日期\n 3.旅遊天數\n 4.封面照片", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            yearTextField.becomeFirstResponder()
            return false
        } else if textField == yearTextField {
            monthTextField.becomeFirstResponder()
            return false
        } else if textField == monthTextField {
            dayTextField.becomeFirstResponder()
            return false
        } else if textField == dayTextField {
            dateTextField.becomeFirstResponder()
            return false
        } else if textField == dateTextField {
            dateTextField.resignFirstResponder()
            let alert = UIAlertController(title: "提醒", message: "請按下下面圖片來設定封面照片", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    func checkInputValue(name:String, year:String, month:String,  day:String, date:String, image:UIImage?) {
        if name == "" || year == "" || month == "" || date == "" || day == "" {
            let alert = UIAlertController(title: "錯誤", message: "輸入框請勿空白", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("所有字數都有值")
            if year.characters.count != 4 || month.characters.count != 2 || day.characters.count != 2 {
                print(year.characters.count)
                print(month.characters.count)
                print(day.characters.count)
                let alert = UIAlertController(title: "請輸入正確的日期格式", message: "yyyy/mm/dd", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                if date.characters.count > 2 {
                    let alert = UIAlertController(title: "請輸入正確的旅遊天數", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                } else {
                    if image == nil {
                        let alert = UIAlertController(title: "錯誤", message: "請設定封面相片", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                        present(alert, animated: true, completion: nil)
                    } else {
                        print("所有值都沒問題")
                        saveTextField(name: name, year: year, month: month, day: day, date: date, image: image!)
                    }
                }
            }
        }
    }
    
    func saveTextField(name:String, year:String, month:String, day:String, date:String, image:UIImage) {
        let imageFilePath = "\(FIRAuth.auth()?.currentUser?.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
        let data = UIImageJPEGRepresentation(image, 0.01)
        let metaData = FIRStorageMetadata()
        FIRStorage.storage().reference().child(imageFilePath).put(data!, metadata: metaData) { (metadata, error) in
            if error != nil {
                return
            } else {
                let fileURL = metadata?.downloadURLs![0].absoluteString
                let time = "\(year)/\(month)/\(day)"
                let newAlbum = self.albumRef.childByAutoId()
                let albumData = ["travelName": name, "time": time, "day":date, "image": fileURL!]
                newAlbum.setValue(albumData)
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
