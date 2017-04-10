//
//  AddLocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class AddLocationViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    var key:String?
    
   
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        checkInputTextAndUpdata(location: locationTextField.text!, day: dayTextField.text!)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        let blurEffect = UIBlurEffect(style:.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.center = view.center
        self.mapView.addSubview(blurEffectView)
        
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
                locationToCoordinate(text: location, day: day)
                
                
            }
        }
    }
    
    func locationToCoordinate(text: String , day:String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (result, error) in
            if error != nil {
                return
            }
            for test in (result?.mapItems)! {
                if test.placemark.name?.characters.count == text.characters.count {
                    self.updataToDatabase(latitude: test.placemark.coordinate.latitude, longitude: test.placemark.coordinate.longitude, day: day)
                    
                    
                }
            }
        }
    }
    
    func updataToDatabase(latitude:Double, longitude:Double, day:String) {
        let mapRef = FIRDatabase.database().reference().child("Album").child(key!).child("photos")
        let newLocation = mapRef.childByAutoId()
        
        print(latitude)
        print(longitude)
        
        let photoDetail = ["day":day, "latitude":latitude, "longitude":longitude] as [String : Any]
        newLocation.setValue([photoDetail])
        
        NotificationCenter.default.post(name: Notification.Name("AddLocation"), object: nil, userInfo: ["location":CLLocationCoordinate2D(latitude: latitude, longitude: longitude), "day": day])
        
       
    }
}
