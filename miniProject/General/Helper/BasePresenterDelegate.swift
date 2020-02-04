//
//  BasePresenterDelegate.swift
//  miniProject
//
//  Created by Min on 2020/2/3.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol BasePresenterDelegate: class {
  func presentAlert(with title: String)
  func showIndicator()
  func dismissIndicator()
}

extension BasePresenterDelegate {
  func showIndicator() {
    DispatchQueue.main.async {
      TAIndicator.show()
    }
  }

  func dismissIndicator() {
    DispatchQueue.main.async {
      TAIndicator.dismiss()
    }
  }
}
