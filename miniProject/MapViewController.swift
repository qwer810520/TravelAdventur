//
//  MapViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var photoDataModel:[PhotoDataModel]!
    var day:String = ""
    var key:String?
    var mapRef = FIRDatabase.database().reference().child("Album").child("photos")
    
    

    @IBAction func addNewLocation(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        print(key)
        pushViewController.key = key!
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.AddLocation(Not:)), name: Notification.Name("AddLocation"), object: nil)
        
        if photoDataModel.count != 0 {
        for x in 0...photoDataModel.count - 1 {
            addPointAnnotation(coordinate: photoDataModel[x].coordinate, day: photoDataModel[x].picturesDay)
            }
        }
    }
    
    func AddLocation(Not:Notification) {
        if let coordinate = Not.userInfo?["location"] as? CLLocationCoordinate2D {
            if let day = Not.userInfo?["day"] as? String {
                let data = PhotoDataModel(photoName: [], picturesDay: day, coordinate: coordinate)
                photoDataModel.append(data)
                addPointAnnotation(coordinate: coordinate, day: day)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    大頭針插入地圖方法
    func addPointAnnotation(coordinate:CLLocationCoordinate2D ,day:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "day \(day)"
        annotation.subtitle = "座標： \(coordinate)"
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        
        mapView.addAnnotation(annotation)
        
    }

//    大頭針細部功能設定
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        let pinID = "Pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinID)
            
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
            let testButton = UIButton.init(type: .infoDark) as UIButton
            pinView?.rightCalloutAccessoryView = testButton
        } else {
            pinView?.annotation = annotation
        }
        
        if annotation.title! == "day 1" {
            pinView?.pinTintColor = UIColor.red
        } else if annotation.title! == "day 2" {
            pinView?.pinTintColor = UIColor.orange
        } else if annotation.title! == "day 3" {
            pinView?.pinTintColor = UIColor.yellow
        } else if annotation.title! == "day 4" {
            pinView?.pinTintColor = UIColor.green
        } else if annotation.title! == "day 5" {
            pinView?.pinTintColor = UIColor.blue
        } else if annotation.title! == "day 6" {
            pinView?.pinTintColor = UIColor.purple
        } else if annotation.title! == "day 7" {
            pinView?.pinTintColor = UIColor.gray
        } else if annotation.title! == "day 8" {
            pinView?.pinTintColor = UIColor.white
        } else if annotation.title! == "day 9" {
            pinView?.pinTintColor = UIColor.black
        } else if annotation.title! == "day 10" {
            pinView?.pinTintColor = UIColor.brown
        }
        
    return pinView
        
    }
    
//    點了Button會呼叫的button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // annotation
        
        if control == view.rightCalloutAccessoryView {
        performSegue(withIdentifier: "photoDetail", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoDetail" {
            let annotationView = sender as! MKAnnotationView
            for photoDetail in photoDataModel {
                if photoDetail.coordinate.latitude == annotationView.annotation?.coordinate.latitude && photoDetail.coordinate.longitude == annotationView.annotation?.coordinate.longitude {
                    if let segue = segue.destination as? ShowPhotoViewController {
                        segue.photoArray = photoDetail.photoName
                    }
                }
            }
        }
    }
    }
