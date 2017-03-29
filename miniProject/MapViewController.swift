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
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addPointAnnotation(latitude: CLLocationDegrees, longitude:CLLocationDegrees ,day:String) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = "day \(day)"
        annotation.subtitle = "緯度： \(latitude), 經度: \(longitude)"
        
        mapView.addAnnotation(annotation)
        
    }
}
