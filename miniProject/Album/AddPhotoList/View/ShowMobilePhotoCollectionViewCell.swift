//
//  ShowMobilePhotoCollectionViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowMobilePhotoCollectionViewCell: UICollectionViewCell {

  lazy private var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()

  var photoData: MobilePhotoModel? {
    didSet {
      guard let photoData = photoData else { return }
      imageView.image = photoData.image

      layer.borderColor = photoData.isSelect ? UIColor.pinkPeacock.cgColor : UIColor.clear.cgColor
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    contentView.layer.borderColor = UIColor.clear.cgColor
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    contentView.addSubview(imageView)
    layer.borderWidth = 4
    setUpLayout()
  }

  private func setUpLayout() {
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
