//
//  TAIndicator.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

class TAIndicator: UIView {

  lazy private var indicator: IndicatorAnimationView = {
    return IndicatorAnimationView()
  }()

  private static var isLoading = false
  private static var indicatorView: TAIndicator?

  // MARK: - Initialization

  init() {
    super.init(frame: UIScreen.main.bounds)
    setUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func removeFromSuperview() {
    super.removeFromSuperview()
    indicator.stopAnimation()
  }

  class func show() {
    guard !isLoading else { return }
    isLoading = true
    indicatorView = TAIndicator()
  }

  class func dismiss() {
    guard isLoading else { return }
    isLoading = false
    indicatorView?.removeFromSuperview()
    indicatorView = nil
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    addSubview(indicator)

    setUpLayout()

    var window: UIWindow?
    if #available(iOS 13.0, *) {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        window = windowScene.windows.first
      }
    } else {
      window = UIApplication.shared.keyWindow
    }
    window?.addSubview(self)
    indicator.startAnimation()
  }

  private func setUpLayout() {
    NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true

    NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 74.0).isActive = true
    NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 74.0).isActive = true
  }
}
