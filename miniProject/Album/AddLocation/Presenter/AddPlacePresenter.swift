//
//  AddPlacePresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/6.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol AddPlacePresenterDelegate: BasePresenterDelegate {
  func dismiss()
}

class AddPlacePresenter: NSObject {

  private(set) var albumInfo = AlbumModel()
  private(set) var addPlaceInfo = AddPlaceModel()

  weak var delegate: AddPlacePresenterDelegate?

  init(albumInfo: AlbumModel, delegate: AddPlacePresenterDelegate? = nil) {
    self.albumInfo = albumInfo
    self.delegate = delegate
    super.init()
    addPlaceInfo.time = albumInfo.startTime
  }

  func setPlaceInfo(with name: String, longitude: Double, latitude: Double) {
    addPlaceInfo.placeName = name
    addPlaceInfo.longitude = longitude
    addPlaceInfo.latitude = latitude
    delegate?.refreshUI()
  }

  func setDateInfo(with date: TimeInterval) {
    addPlaceInfo.time = date
    delegate?.refreshUI()
  }

  // MARK: - API Methods

  func addNewPlaceInfo() {
    do {
      try addPlaceInfo.checkPlaceInfoIsEqual()
      delegate?.showIndicator()
      FirebaseManager2.shared.addNewPlaceData(albumid: albumInfo.id, placeData: addPlaceInfo) { [weak self] res in
        switch res {
          case .failure(let error):
            self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
          case .success:
            self?.delegate?.dismiss()
        }
      }

    } catch {
      delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
    }
  }
}
