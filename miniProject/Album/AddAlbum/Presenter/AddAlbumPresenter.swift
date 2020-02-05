//
//  AddAlbumPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol AddAlbumPresenterDelegate: BasePresenterDelegate {
  func dismissVC()
  func presentImagePickerVC()
}

class AddAlbumPresenter: NSObject {

  private(set) var addAlbum = AddAlbumModel()

  weak var delegate: AddAlbumPresenterDelegate?

  init(delegate: AddAlbumPresenterDelegate? = nil) {
    self.delegate = delegate
    super.init()
  }

  func setAlbumName(with name: String) {
    addAlbum.title = name
    delegate?.refreshUI()
  }

  func setAlbumStartDate(with date: TimeInterval) {
    addAlbum.startTime = date
    delegate?.refreshUI()
  }

  func setAlbumDayRange(with day: Int) {
    addAlbum.day = day
    delegate?.refreshUI()
  }

  func setAlbumCoverImage(with image: UIImage) {
    addAlbum.coverPhoto = image
    delegate?.refreshUI()
  }

  func checkAlbumAuthority() {
    checkPermission { [weak self] status in
      switch status {
        case true:
          self?.delegate?.presentImagePickerVC()
        case false:
          self?.delegate?.presentAlert(with: "相簿權限尚未開啟", message: "是否前往設定開啟相機以及相簿權限", checkAction: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }, cancelTitle: "取消", cancelAction: nil)
      }
    }
  }

  // MARK: - API Methods

  func addAlnum() {
    delegate?.showIndicator()
    do {
      try addAlbum.checkFormatter()
      FirebaseManager2.shared.addNewAlbumData(model: addAlbum) { [weak self] res in
        self?.delegate?.dismissIndicator()
        switch res {
          case .success:
            self?.delegate?.dismissVC()
          case .failure(let error):
            self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
        }
      }
    } catch {
      delegate?.dismissIndicator()
      delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
    }
  }
}
