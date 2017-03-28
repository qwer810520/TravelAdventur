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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationMapMark(coordinateN: Float, coordinateE:Float) {
        let geoCoder = CHAnnotation()
        geoCoder.g
        geoCoder.geocodeAddressString(key) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error != nil {
                print(error)
                return
            } else {
                if let mark = placemarks {
                    let mark = placemarks?[0]
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = key
                    
                    if let location = mark?.location {
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        
                        
                    }
                }
            }
        }
    }
}
