//
//  MapViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var photoDataModel:[PhotoDataModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        for x in 0...photoDataModel.count - 1 {
            addPointAnnotation(coordinate: photoDataModel[x].coordinate, day: photoDataModel[x].picturesDay)
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
        
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // annotation
        
        if control == view.rightCalloutAccessoryView {
        performSegue(withIdentifier: "showPhoto", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let annotationView = sender as! MKAnnotationView
        print()
        

        for photoDetail in photoDataModel {
            if photoDetail.coordinate.latitude == annotationView.annotation?.coordinate.latitude && photoDetail.coordinate.longitude == annotationView.annotation?.coordinate.longitude {
                if let segue = segue.destination as? ShowPhotoViewController {
                    segue.photoArray = photoDetail.photoName
                }
            }
        }
        
    }

    }
