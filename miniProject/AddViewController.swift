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
            return false
        }
        return true
    }
    
    
    func saveTextField(name:String, year:String, month:String, date:String, day:String) {
        let date = "\(year)/\(month)/\(date)"
        let newAlbum = albumRef.childByAutoId()
//        let albumData =
    }
    
    func saveImage(picture: UIImage) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            buttonImage.image = picture
            backgroundImage.image = picture
            buttonImage.clipsToBounds = true
            saveImage(picture: picture)
        }
        
        dismiss(animated: true, completion: nil)
    }


}
