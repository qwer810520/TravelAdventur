//
//  LocationPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/5.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol LocationPresenterDelegate: BasePresenterDelegate { }

class LocationPresenter: NSObject {

  weak var delegate: LocationPresenterDelegate?
  private var selectAlbum = AlbumModel()
  private(set) var placeList = [PlaceModel]()

  // MARK: - Initialization

  init(albumInfo: AlbumModel, delegate: LocationPresenterDelegate? = nil) {
    self.selectAlbum = albumInfo
    self.delegate = delegate
    super.init()
  }

  func getAlbumID() -> String {
    return selectAlbum.id
  }

  // MARK: - API Methods

  func getPlaceList() {
    delegate?.showIndicator()
    FirebaseManager.shared.getPlaceList(albumID: selectAlbum.id) { [weak self] res in
      self?.delegate?.dismissIndicator()
      switch res {
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
        case .success(let infoList):
          self?.placeList = infoList
          if !infoList.isEmpty {
            self?.placeList[0].isMark = true
          }
          self?.delegate?.refreshUI()
      }
    }
  }
}
