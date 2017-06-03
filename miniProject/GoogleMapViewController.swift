//
//  GoogleMapViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/1.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseServer.firebase().getPhotoArrayData(select: 0).selectSwitch = true
        
        let camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        mapView.camera = camera
        mapView.mapType = .normal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func inputLocationMarker(coordinate: CLLocationCoordinate2D, changeColor:Bool) {
        switch changeColor {
        case true:
            let orangeIcon = UIImage(named: "orangeIcon")
            let marker = GMSMarker(position: coordinate)
            marker.icon = orangeIcon
            marker.map = mapView
        case false:
            let redIcon = UIImage(named: "redIcon")
            let marker = GMSMarker(position: coordinate)
            marker.icon = redIcon
            marker.map = mapView            
        }
        
    }
    
    

}
