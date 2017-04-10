//
//  AddLocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class AddLocationViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var backgroundImage: UIImageView!
    
     var mapRef = FIRDatabase.database().reference().child("Album").child("photos")
    
   
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        checkInputTextAndUpdata(location: locationTextField.text!, day: dayTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style:.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.center = view.center
        self.backgroundImage.addSubview(blurEffectView)
        
        locationTextField.delegate = self
        dayTextField.delegate = self
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
    
    func checkInputTextAndUpdata(location:String, day:String) {
        if location == "" || day == "" {
            let alert = UIAlertController(title: "錯誤", message: "輸入框不能為空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        } else {
            if day.characters.count > 2 {
                let alert = UIAlertController(title: "錯誤", message: "請輸入正確的天數", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                print("資料都沒問題")
                locationToCorrdinate(location: location)
                
            }
        }
    }
    
    func locationToCorrdinate(location:String) {
         let locationType = CLGeocoder()
//        let request = MKLocalSearchRequest()
//        request.
        locationType.geocodeAddressString(location) { (placemarks, error) in
            if error != nil {
                return
            }
            if placemarks != nil && (placemarks?.count)! > 0 {
                    let placemark = placemarks?[0] as! CLPlacemark
                    print(location)
                    print(placemark.location?.coordinate.latitude)
                    print(placemark.location?.coordinate.longitude)
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
}
