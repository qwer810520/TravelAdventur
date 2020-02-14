//
//  ShowProfileTableViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowProfileTableViewCell: UITableViewCell {

  lazy private var userImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.layer.cornerRadius = 50
    view.layer.masksToBounds = true
    return view
  }()

  lazy private var userNameLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.tintColor = .white
    view.textAlignment = .center
    return view
  }()

  lazy private var bottomLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .defaultBackgroundColor
    return view
  }()

  var userModel: LoginUserModel? {
    didSet {
      guard let user = userModel else { return }
      userNameLabel.text = user.name
      userImageView.downloadImage(urlStr: user.photoURL)
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Method

  private func setUserInterface() {
    selectionStyle = .none
    backgroundColor = .white
    contentView.addSubviews([userImageView, userNameLabel, bottomLine])
    setUpLayout()
  }

  private func setUpLayout() {
    NSLayoutConstraint(item: userImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint(item: userImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[userNameLabel]|",
      options: [],
      metrics: nil,
      views: ["userImageView": userImageView, "userNameLabel": userNameLabel]))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-20-[userImageView(100)]-20-[userNameLabel]-10-|",
      options: [],
      metrics: nil,
      views: ["userImageView": userImageView, "userNameLabel": userNameLabel]))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[bottomLine]-10-|",
      options: [],
      metrics: nil,
      views: ["bottomLine": bottomLine]))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[bottomLine(1)]|",
      options: [],
      metrics: nil,
      views: ["bottomLine": bottomLine]))
  }
}
