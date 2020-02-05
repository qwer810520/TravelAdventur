//
//  LocationMapView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps

protocol LocationMapViewDelegate: class {
  func didSelectItem(with placeInfo: PlaceModel)
}

class LocationMapView: UIView {

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
    view.register(with: [ShowPlaceCollectionViewCell.self])
    view.delegate = self
    view.dataSource = self
    return view
  }()

  private var willDisplayIndex: Int = 0
  weak var delegate: LocationMapViewDelegate?
  private var placeList = [PlaceModel]()

  // MARK: - Initialization

  init(delegate: LocationMapViewDelegate? = nil) {
    self.delegate = delegate
    super.init(frame: .zero)
    setUsetInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func removeFromSuperview() {
    super.removeFromSuperview()
    mapView?.removeFromSuperview()
    mapView = nil
  }

  func setUpUI(with infoList: [PlaceModel]) {
    placeList = infoList
    collectionView.reloadData()
    setUpPlaceMarker()
  }

  // MARK: - Private Methods

  private func setUsetInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    guard let mapView = mapView else { return }
    addSubview(mapView)
    mapView.addSubview(collectionView)
    setUpAutoLayout()
  }

  private func setUpAutoLayout() {
    guard let mapView = mapView else { return }
    let views: [String: Any] = ["mapView": mapView, "collectionView": collectionView]

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[mapView]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
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

  private func setUpPlaceMarker() {
     guard let mapView = mapView else { return }
     mapView.clear()
     mapView.camera = GMSCameraPosition.camera(withLatitude: 23.65, longitude: 120.982024, zoom: 7.7)
     placeList.forEach {
       let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
      marker.icon = $0.isMark ? "location_place_display_icon".toImage : "location_place_default_icon".toImage
       marker.map = mapView
     }
   }
}

  // MARK: - UICollectionViewDelegate

extension LocationMapView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectItem(with: placeList[indexPath.row])
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    willDisplayIndex = indexPath.row
  }

  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard willDisplayIndex != indexPath.row else { return }
    placeList[willDisplayIndex].isMark = true
    placeList[indexPath.row].isMark = false
    willDisplayIndex = indexPath.row
    setUpPlaceMarker()
  }
}

  // MARK: - UICollectionViewDataSource

extension LocationMapView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return placeList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(with: ShowPlaceCollectionViewCell.self, for: indexPath)
    cell.placeData = placeList[indexPath.row]
    return cell
  }
}
