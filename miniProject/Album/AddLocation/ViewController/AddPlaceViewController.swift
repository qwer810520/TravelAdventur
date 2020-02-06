//
//  AddLocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddPlaceViewController: ParentViewController {

  var album: AlbumModel?
  private var presenter: AddPlacePresenter?

  lazy var addPlaceView: AddPlaceView = {
    return AddPlaceView(delegate: self)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AddPlacePresenter(albumInfo: album ?? AlbumModel(), delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterface()
  }

  // MARK: - private Method

  private func setUserInterface() {
    setNavigation(title: "Add Place", barButtonType: .dismiss_)

    view.addSubview(addPlaceView)
    setUpAutoLayout()

    refreshUI()
  }

  private func setUpAutoLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[addPlaceView]|",
      options: [],
      metrics: nil,
      views: ["addPlaceView": addPlaceView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[addPlaceView]|",
      options: [],
      metrics: nil,
      views: ["addPlaceView": addPlaceView]))
  }
}

  // MARK: - AddPlaceDelegate

extension AddPlaceViewController: AddPlaceDelegate {
  func placeTextFieldEditingBegin() {
    let searchPlaceVC = SearchPlaceViewController()
    searchPlaceVC.delegate = self
    present(searchPlaceVC, animated: true, completion: nil)
  }

  func didSelectDate(with date: TimeInterval) {
    presenter?.setDateInfo(with: date)
  }

  func addPlaceButtonDidPressed() {
    presenter?.addNewPlaceInfo()
  }
}

  // MARK: - AddPlacePresenterDelegate

extension AddPlaceViewController: AddPlacePresenterDelegate {
  func dismiss() {
    dismiss(animated: true, completion: nil)
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func refreshUI() {
    guard let presenter = presenter else { return }
    addPlaceView.setInfo(with: presenter.albumInfo, placeInfo: presenter.addPlaceInfo)
  }
}

  // MARK: - GMSAutocompleteViewControllerDelegate

extension AddPlaceViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    presenter?.setPlaceInfo(with: place.name ?? "", longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
    
    dismiss()
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    showAlert(title: error.localizedDescription)
  }

  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss()
  }
}
