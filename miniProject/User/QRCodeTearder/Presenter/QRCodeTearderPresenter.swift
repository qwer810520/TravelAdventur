//
//  QRCodeTearderPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/14.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import Foundation

protocol QRCodeTearderPresenterDelegate: BasePresenterDelegate {
  func dismissVC()
  func captureSessionStartRunning()
}

class QRCodeTearderPresenter: NSObject {

  weak var delegate: QRCodeTearderPresenterDelegate?

  init(delegate: QRCodeTearderPresenterDelegate? = nil) {
    self.delegate = delegate
    super.init()
  }

  // MARK: - API Methods

  func checkAlbumStatus(withID id: String) {
    delegate?.showIndicator()
    FirebaseManager.shared.checkAlbumStatus(id: id) { [weak self] result in
      self?.delegate?.dismissIndicator()
      switch result {
        case .success:
          self?.delegate?.presentAlert(with: "Added successfully", message: nil, checkAction: { _ in
            self?.delegate?.dismissVC()
          }, cancelTitle: nil, cancelAction: nil)
        case .failure:
          self?.delegate?.presentAlert(with: "Error", message: "Please scan the correct QRCode", checkAction: { _ in
            self?.delegate?.captureSessionStartRunning()
          }, cancelTitle: nil, cancelAction: nil)
      }
    }
  }
}
