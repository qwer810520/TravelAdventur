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
    
    @IBAction func AddPhotoLocationButton(_ sender: UIBarButtonItem) {
        let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController")
        navigationController?.pushViewController(addLocationViewController!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        mapView.camera = camera
        mapView.mapType = .normal
        
        if FirebaseServer.firebase().getPhotoArrayCount() != 0 {
            for i in FirebaseServer.firebase().getSelectAlbumData().photos {
                inputLocationMarker(coordinate: i.coordinate, changeColor: i.selectSwitch)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(newChangeColor(Not:)), name: Notification.Name("changColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushToPhotoController(Not:)), name: Notification.Name("pushToController"), object: nil)
    }
    
    func newChangeColor(Not:Notification) {
        if let changeColor = Not.userInfo?["changSwitch"] as? Bool {
            if changeColor == true {
                mapView.clear()
                for i in FirebaseServer.firebase().getSelectAlbumData().photos {
                inputLocationMarker(coordinate: i.coordinate, changeColor: i.selectSwitch)
                }
            }
        }
    }
    
    func pushToPhotoController(Not:Notification) {
        if let pushSwitch = Not.userInfo?["push"] as? Bool {
            if pushSwitch == true {
                let showPhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowPhotoViewController")
                navigationController?.pushViewController(showPhotoViewController!, animated: true)
            }
        }
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
