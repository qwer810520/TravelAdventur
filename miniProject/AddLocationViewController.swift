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
import SVProgressHUD


class AddLocationViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate{
    
    @IBAction func locationTestField(_ sender: UITextField) {
        if Library.isInternetOk() == true {
            let searchPlaceController = GMSAutocompleteViewController()
            searchPlaceController.tableCellSeparatorColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 1.0)
            searchPlaceController.tableCellBackgroundColor = UIColor.white
            searchPlaceController.tintColor = UIColor.white
            searchPlaceController.primaryTextColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            searchPlaceController.primaryTextHighlightColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 1.0)
            searchPlaceController.delegate = self
            present(searchPlaceController, animated: true, completion: nil)
        } else {
             present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
 
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBAction func dateTextField(_ sender: UITextField) {
        selectDateSet(textField: sender)
    }
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        checkInputTextAndUpdata()
    }
    
    let selectDatePickerView = UIDatePicker()
    var selectDate:TimeInterval?
    var PhotoData = savePhotoDataModel(photoID: String(), albumID: String(), locationName: String(), picturesDay: Double(), latitude: CLLocationDegrees(), longitude: CLLocationDegrees())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScreen.main.brightness = CGFloat(FirebaseServer.firebase().getScreenbrightness())
        locationTextField.delegate = self
        dayTextField.delegate = self
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = backImageView.bounds
        blurEffectView.center = backImageView.center
        backImageView.addSubview(blurEffectView)
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
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
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
    
    
    func checkInputTextAndUpdata() {
        if locationTextField.text == "" || dayTextField.text == "" {
            present(Library.alertSet(title: "錯誤", message: "輸入框不能為空", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        } else {
            let newPhotoID = FirebaseServer.firebase().getRefPath(getPath: "photo").childByAutoId().key
            PhotoData.picturesDay = selectDate!
            PhotoData.albumID = FirebaseServer.firebase().getSelectAlbumData().albumID
            PhotoData.photoID = newPhotoID
            FirebaseServer.firebase().savePhotoDataToFirebase(photoID: newPhotoID, photoData: PhotoData, completion: {
                NotificationCenter.default.post(name: Notification.Name("updata"), object: nil, userInfo: ["switch": "Place"])
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

extension AddLocationViewController {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationTextField.text = place.name
        PhotoData.locationName = place.name
        PhotoData.latitude = place.coordinate.latitude
        PhotoData.longitude = place.coordinate.longitude
    
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        present(Library.alertSet(title: "錯誤", message: "\(error.localizedDescription)", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }), animated: true, completion: nil)
        
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
