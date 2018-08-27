//
//  LocationMapView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationMapView: UIView {
    weak var delegate: UICollectionViewDelegate?
    weak var dataSource: UICollectionViewDataSource?
    
    init(delegate: UICollectionViewDelegate? = nil, dataSource: UICollectionViewDataSource? = nil) {
        self.delegate = delegate
        self.dataSource = dataSource
        super.init(frame: .zero)
        setUsetInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LocationMapView deinit")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    // MARK: - Private Method
    
    private func setUsetInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        guard let mapView = mapView else { return }
        self.addSubview(mapView)
        mapView.addSubview(collectionView)
        
        let views: [String: Any] = ["mapView": mapView, "collectionView": collectionView]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[mapView]|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mapView]|",
            options: [],
            metrics: nil,
            views: views))
        
        mapView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            options: [],
            metrics: nil,
            views: views))
        
        mapView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[collectionView(160)]-55-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init Element
    
    lazy var mapView: GMSMapView? = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.mapType = .normal
        view.camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(ShowPlaceCollectionViewCell.self, forCellWithReuseIdentifier: ShowPlaceCollectionViewCell.identifier)
        view.delegate = delegate
        view.dataSource = dataSource
        return view
    }()
}
