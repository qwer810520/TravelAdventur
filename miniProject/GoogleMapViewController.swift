//
//  GoogleMapViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/1.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMaps
import GooglePlaces


class GoogleMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var qrcodeView: UIImageView!
    @IBOutlet weak var segmentedSet: UISegmentedControl!
    
    @IBAction func cheangeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.isHidden = false
            placeView.isHidden = false
            qrcodeView.isHidden = true
            UIScreen.main.brightness = CGFloat(FirebaseManager.shared.getScreenbrightness())
        } else {
            mapView.isHidden = true
            placeView.isHidden = true
            qrcodeView.isHidden = false
            UIScreen.main.brightness = 1.0
        }
    }
    
    @IBAction func AddPhotoLocationButton(_ sender: UIBarButtonItem) {
        let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController")
        navigationController?.pushViewController(addLocationViewController!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrcodeView.isHidden = true
        
        qrcodeView.image = Library.qrcodeImage(str: FirebaseManager.shared.getSelectAlbumData().albumID, image: qrcodeView)
    
        let camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        mapView.camera = camera
        mapView.mapType = .normal
        mapView.clear()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if segmentedSet.selectedSegmentIndex == 1 {
            segmentedSet.selectedSegmentIndex = 0
            mapView.isHidden = false
            placeView.isHidden = false
            qrcodeView.isHidden = true
            UIScreen.main.brightness = CGFloat(FirebaseManager.shared.getScreenbrightness())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSVP(Not:)), name: Notification.Name("placeSVP"), object: nil)
    }
    
    @objc func showSVP(Not:Notification) {
        if let SVPSwitch = Not.userInfo?["switch"] as? Bool {
            if SVPSwitch == true {
                SVProgressHUD.show(withStatus: "載入中...")
            } else {
                SVProgressHUD.showSuccess(withStatus: "完成")
                SVProgressHUD.dismiss(withDelay: 1.5)
                FirebaseManager.shared.getPhotoArrayData(select: 0).selectSwitch = true
                updateColor()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FirebaseManager.shared.getPhotoArrayCount() != 0 {
            for i in FirebaseManager.shared.getSelectAlbumData().photos {
                inputLocationMarker(coordinate: i.coordinate, changeColor: i.selectSwitch)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(newChangeColor(Not:)), name: Notification.Name("changColor"), object: nil)
    }
    
    
    
    @objc func newChangeColor(Not:Notification) {
        if let changeColor = Not.userInfo?["changSwitch"] as? Bool {
            if changeColor == true {
                updateColor()
            }
        }
    }
    
    private func updateColor() {
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        mapView.camera = camera
        for i in FirebaseManager.shared.getSelectAlbumData().photos {
            inputLocationMarker(coordinate: i.coordinate, changeColor: i.selectSwitch)
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
