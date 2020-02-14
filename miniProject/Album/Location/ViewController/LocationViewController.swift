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

  lazy private var segmented: UISegmentedControl = {
    let view = UISegmentedControl(items: ["Place", "Shared Album"])
    view.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 30)
    view.tintColor = .white
    view.selectedSegmentIndex = 0
    view.addTarget(self, action: #selector(segmentedValueChanged(sender:)), for: .valueChanged)
    return view
  }()

  fileprivate var locationMapView: LocationMapView?
  fileprivate var qrcodeView: AddAlbumQRCodeView?
  private var presenter: LocationPresenter?
  fileprivate var willDisplayIndex: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = LocationPresenter(albumInfo: selectAlbum ?? AlbumModel(), delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterFace()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    locationMapView?.removeFromSuperview()
    locationMapView = nil
  }

  // MARK: - private Method

  private func setUserInterFace() {
    setNavigation(title: nil, barButtonType: .back_addPlace)
    navigationItem.titleView = segmented
    setUpLocationMapView()
  }

  private func setUpLocationMapView() {
    presenter?.getPlaceList()
    locationMapView = LocationMapView(delegate: self)
    segmented.selectedSegmentIndex = 0
    guard let mapView = locationMapView else { return }
    view.addSubview(mapView)
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[mapView]|",
      options: [],
      metrics: nil,
      views: ["mapView": mapView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[mapView]|",
      options: [],
      metrics: nil,
      views: ["mapView": mapView]))
  }

  private func setUpQRCodeView() {
    qrcodeView = AddAlbumQRCodeView(id: presenter?.getAlbumID() ?? "")
    guard let qrView = qrcodeView else { return }
    view.addSubview(qrView)

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[qrView]|",
      options: [],
      metrics: nil,
      views: ["qrView": qrView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[qrView]|",
      options: [],
      metrics: nil,
      views: ["qrView": qrView]))

    qrView.layoutIfNeeded()
  }

  // MARK: - Action Method

  @objc private func segmentedValueChanged(sender: UISegmentedControl) {
    DispatchQueue.main.async { [weak self] in
      switch sender.selectedSegmentIndex {
        case 0:
          UIScreen.main.brightness = (UserDefaults.standard.object(forKey: UserDefaultsKey.screenBrightness.rawValue) as? CGFloat) ?? 0.5
          self?.setNavigation(title: nil, barButtonType: .back_addPlace)
          self?.qrcodeView?.removeFromSuperview()
          self?.qrcodeView = nil
          self?.setUpLocationMapView()
        case 1:
          UserDefaults.standard.set(UIScreen.main.brightness, forKey: UserDefaultsKey.screenBrightness.rawValue)
          UIScreen.main.brightness = 1.0
          self?.setNavigation(title: nil, barButtonType: .back_)
          self?.locationMapView?.removeFromSuperview()
          self?.locationMapView = nil
          self?.setUpQRCodeView()
        default:
          break
      }
    }
  }

  override func addButtonDidPressed() {
    let addPlaceVC = AddPlaceViewController()
    addPlaceVC.album = selectAlbum
    let navigation = TANavigationController(rootViewController: addPlaceVC)
    present(navigation, animated: true, completion: nil)
  }
}

  // MARK: - LocationPresenterDelegate

extension LocationViewController: LocationPresenterDelegate {
  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func refreshUI() {
    locationMapView?.setUpUI(with: presenter?.placeList ?? [])
  }
}

  // MARK: - LocationMapViewDelegate

extension LocationViewController: LocationMapViewDelegate {
  func didSelectItem(with placeInfo: PlaceModel) {
    let showPhotoListVC = ShowPhotoListViewController()
    showPhotoListVC.placeData = placeInfo
    navigationController?.pushViewController(showPhotoListVC, animated: true)
  }
}
