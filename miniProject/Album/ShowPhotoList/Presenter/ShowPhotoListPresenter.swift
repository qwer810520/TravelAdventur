//
//  ShowPhotoListPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/7.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol ShowPhotoListPresenterDelegate: BasePresenterDelegate {  }

class ShowPhotoListPresenter: NSObject {

  private(set) var placeInfo = PlaceModel()
  private(set) var photoURLList = [String]()
  weak var delegate: ShowPhotoListPresenterDelegate?

  init(placeInfo: PlaceModel ,delegate: ShowPhotoListPresenterDelegate? = nil) {
    self.placeInfo = placeInfo
    self.delegate = delegate
    super.init()
  }

  // MARK: - API Methods

  func getPhotoList() {
    delegate?.showIndicator()
    FirebaseManager.shared.getPlaceData(id: placeInfo.placeID) { [weak self] res in
      self?.delegate?.dismissIndicator()
      switch res {
        case .success(let urlList):
          self?.photoURLList = urlList
          self?.delegate?.refreshUI()
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }
}
