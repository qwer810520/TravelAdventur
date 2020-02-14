//
//  ShowPhotosCollectionViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowPhotosCollectionViewCell: UICollectionViewCell {

  lazy private var imageView: UIImageView = {
     let view = UIImageView()
     view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
     return view
   }()

  var imageURL: String? {
    didSet {
      guard let str = imageURL, !str.isEmpty else { return }
      imageView.downloadImage(urlStr: str, withContentMode: .scaleToFill)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    contentView.addSubview(imageView)
    setUpAutoLayout()
  }

  private func setUpAutoLayout() {
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[imageView]|",
      options: [],
      metrics: nil,
      views: ["imageView": imageView]))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[imageView]|",
      options: [],
      metrics: nil,
      views: ["imageView": imageView]))
  }
}
