//
//  MainPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol MainPresenterDelegate: BasePresenterDelegate { }

class MainPresenter: NSObject {

  private(set) var albumList = [AlbumModel]() {
    didSet {
      delegate?.refreshUI()
    }
  }
  weak var delegate: MainPresenterDelegate?

  init(delegate: MainPresenterDelegate? = nil) {
    self.delegate = delegate
    super.init()
    UIScreen.main.brightness = (UserDefaults.standard.object(forKey: UserDefaultsKey.screenBrightness.rawValue) as? CGFloat) ?? 0.5
  }

  // MARK: - API Methods

  func getAlbumInfo(with indexPath: IndexPath) -> AlbumModel {
    return albumList[indexPath.row]
  }

  func getAlbumList() {
    delegate?.showIndicator()
    FirebaseManager2.shared.getAlbumData { [weak self] res in
      self?.delegate?.dismissIndicator()
      switch res {
        case .success(let albumList):
          self?.albumList = albumList
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }
}
