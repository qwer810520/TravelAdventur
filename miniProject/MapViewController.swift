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
        
        for x in 0...photoDataModel.count - 1 {
                addPointAnnotation(latitude: photoDataModel[x].latitude, longitude: photoDataModel[x].longitude, day: photoDataModel[x].picturesDay)
            
            mapView.delegate = self
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    大頭針插入地圖方法
    func addPointAnnotation(latitude: CLLocationDegrees, longitude:CLLocationDegrees ,day:String) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = "day \(day)"
        annotation.subtitle = "緯度： \(latitude), 經度: \(longitude)"
        
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
            
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            
        } else {
            pinView?.annotation = annotation
        }
        
        
        return pinView
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        navigationController?.push(PhotoCollectionViewController, animated: true)
    }

    }
