//
//  AddAlbumQRCodeView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class AddAlbumQRCodeView: UIView {
  var id: String

  lazy var qrcodeImageView: UIImageView = {
    let widthAndHeight: CGFloat = UIScreen.main.bounds.width - (80 * 2)
    return UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width - widthAndHeight) / 2 , y: 150, width: widthAndHeight, height: widthAndHeight))
  }()

  lazy private var descriptionLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: - Initialization

  init(id: String) {
    self.id = id
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func removeFromSuperview() {
    super.removeFromSuperview()
    qrcodeImageView.image = nil
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    addSubview(qrcodeImageView)
    setUpAutoLayout()
  }

  private func setUpAutoLayout() {
    qrcodeImageView.image = id.toQRCode(with: qrcodeImageView)
  }
}
