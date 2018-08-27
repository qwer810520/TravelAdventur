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
    fileprivate var placeList = [PlaceModel]() {
        didSet {
            guard !placeList.isEmpty else { return }
            print("開始做事")
            setPlaceMarker()
//            locationMapView?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            locationMapView?.collectionView.reloadData()
        }
    }
    
    lazy var segmented: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Place", "Shared Album"])
        view.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 30)
        view.tintColor = .white
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentedValueChanged(sender:)), for: .valueChanged)
        return view
    }()
    
    fileprivate var locationMapView: LocationMapView?
    fileprivate var willDisplayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlaceList()
        setUserInterFace()
    }
    
    // MARK: - private Method
    
    private func setUserInterFace() {
        setNavigation(title: nil, barButtonType: .Back_Add)
        navigationItem.titleView = segmented
        setLocationMapView()
    }
    
    private func setLocationMapView() {
        locationMapView = LocationMapView(delegate: self, dataSource: self)
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
        
//        setCamera(complection: nil)
    }
    
    /*
    private func setCamera(complection: (() -> ())?) {
        let camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        guard let mapView = locationMapView?.mapView else { return }
        mapView.camera = camera
        mapView.mapType = .normal
        mapView.clear()
        guard let complection = complection else { return }
        complection()
    }
     */
    
    private func setPlaceMarker() {
        guard let mapView = locationMapView?.mapView else { return }
        mapView.clear()
        mapView.camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        print("開始插圖標")
        placeList.forEach {
            print($0.latitude)
            print($0.longitude)
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
        }
    }
    
    // MARK: - Action Method
    
    @objc private func segmentedValueChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
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
        print("willDisplay", indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didEndDisplaying", indexPath.row)
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
