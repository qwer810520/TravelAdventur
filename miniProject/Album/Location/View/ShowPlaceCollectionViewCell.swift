//
//  ShowPlaceCollectionViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowPlaceCollectionViewCell: UICollectionViewCell {

  var placeData: PlaceModel? {
    didSet {
      guard let place = placeData else { return }
      nameLabel.text = place.name
      timeLabel.text = place.time.dateToString(type: .all)
      guard !place.photoList.isEmpty else {
        imageView.setPlaceholdImage()
        return
      }
      imageView.downloadImage(urlStr: place.photoList[0], withContentMode: .scaleAspectFill)
    }
  }

  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    if #available(iOS 11, *) {
      imageView.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMinXMaxYCorner]
    }
    return imageView
  }()

  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUserUnterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  // MARK: - private method

  private func setUserUnterface() {
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 10
    contentView.addSubviews([imageView, nameLabel, timeLabel])
    setAutoLayout()
  }

  private func setAutoLayout() {

    let views: [String: Any] = ["imageView": imageView, "nameLabel": nameLabel, "timeLabel": timeLabel]

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[imageView]|",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-40-[nameLabel(40)]-30-[timeLabel(20)]",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[imageView(200)]-10-[nameLabel]-10-|",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[imageView]-10-[timeLabel]-10-|",
      options: [],
      metrics: nil,
      views: views))
  }
}
