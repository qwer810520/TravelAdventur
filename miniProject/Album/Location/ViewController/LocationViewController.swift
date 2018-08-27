//
//  LocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationViewController: ParentViewController {
    
    var selectAlbum: AlbumModel?
    fileprivate var placeList = [PlaceModel]()
    
    lazy var segmented: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Place", "Shared Album"])
        view.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 30)
        view.tintColor = .white
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentedValueChanged(sender:)), for: .valueChanged)
        return view
    }()
    
    fileprivate var locationMapView: LocationMapView?
    fileprivate var qrcodeView: AddAlbumQRCodeView?
    fileprivate var willDisplayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlaceList()
        setUserInterFace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationMapView?.removeFromSuperview()
        locationMapView = nil
    }
    
    // MARK: - private Method
    
    private func setUserInterFace() {
        setNavigation(title: nil, barButtonType: .Back_Add)
        navigationItem.titleView = segmented
        setLocationMapView()
    }
    
    private func setLocationMapView() {
        locationMapView = LocationMapView(delegate: self, dataSource: self)
        segmented.selectedSegmentIndex = 0
        guard let mapView = locationMapView else { return }
        view.addSubview(mapView)
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(getNaviHeight())-[mapView]|",
            options: [],
            metrics: nil,
            views: ["mapView": mapView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[mapView]|",
            options: [],
            metrics: nil,
            views: ["mapView": mapView]))
    }
    
    private func setQRCodeView() {
        qrcodeView = AddAlbumQRCodeView(id: (selectAlbum?.id)!)
        guard let qrView = qrcodeView else { return }
        view.addSubview(qrView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[qrView]|",
            options: [],
            metrics: nil,
            views: ["qrView": qrView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(getNaviHeight())-[qrView]|",
            options: [],
            metrics: nil,
            views: ["qrView": qrView]))
        
        qrView.layoutIfNeeded()
        
        qrView.QRImageView.image = TAStyle.setQRImage(str: (selectAlbum?.id)!, image: qrView.QRImageView)
    }
    
    private func setPlaceMarker() {
        guard let mapView = locationMapView?.mapView else { return }
        mapView.clear()
        mapView.camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        placeList.forEach {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
            marker.icon = $0.isMark ? UIImage(named: "orangeIcon") : UIImage(named: "redIcon")
            marker.map = mapView
        }
    }
    
    // MARK: - API Method
    
    private func getPlaceList() {
        startLoading()
        FirebaseManager.shared.getPlaceList(albumID: (selectAlbum?.id)!) { [weak self] (responsePlaceList, error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(type: .check, title: (error?.localizedDescription)!)
                return
            }
            guard !responsePlaceList.isEmpty else {
                
                return
            }
            var placeList = responsePlaceList
            placeList[0].isMark = true
            self?.placeList = placeList
            
            self?.setPlaceMarker()
            //            locationMapView?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            self?.locationMapView?.collectionView.reloadData()
        }
    }
    
    // MARK: - Action Method
    
    @objc private func segmentedValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIScreen.main.brightness = UserDefaults.standard.object(forKey: UserDefaultsKey.ScreenBrightness.rawValue) as! CGFloat
            setNavigation(title: nil, barButtonType: .Back_Add)
            qrcodeView?.removeFromSuperview()
            qrcodeView = nil
            setLocationMapView()
            setPlaceMarker()
        case 1:
             UserDefaults.standard.set(UIScreen.main.brightness, forKey: UserDefaultsKey.ScreenBrightness.rawValue)
             UIScreen.main.brightness = 1.0
            setNavigation(title: nil, barButtonType: .Back_)
            locationMapView?.removeFromSuperview()
            locationMapView = nil
            setQRCodeView()
        default:
            break
        }
    }
    
    override func addButtonDidPressed() {
        let vc = TANavigationController(rootViewController: AddPlaceViewController())
        guard let rootVC = vc.viewControllers.first as? AddPlaceViewController else { return }
        rootVC.album = selectAlbum
        present(vc, animated: true, completion: nil)
    }
}

    // MARK: - UICollectionViewDelegate

extension LocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayIndex = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let willDisplayIndex = willDisplayIndex,  willDisplayIndex != indexPath.row else { return }
        placeList[willDisplayIndex].isMark = true
        placeList[indexPath.row].isMark = false
        setPlaceMarker()
    }
}

    // MARK: - UICollectionViewDataSource

extension LocationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowPlaceCollectionViewCell.identifier, for: indexPath) as! ShowPlaceCollectionViewCell
        cell.placeData = placeList[indexPath.row]
        return cell
    }
}
