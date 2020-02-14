//
//  searchQRcodeOrTouchIDTableViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

enum QRCodeOrTouchIDCellType {
  case touchID, qrcode
}

extension QRCodeOrTouchIDCellType {
  var titleImage: UIImage? {
    switch self {
      case .qrcode:
        return "qrcode".toImage
      case .touchID:
        return "Touch ID".toImage
    }
  }

  var title: String {
    switch self {
      case .qrcode:
        return "新增相簿"
      case .touchID:
        return "Touch ID登入"
    }
  }
}

protocol SearchQRcodeOrTouchIDCellDelegate: class {
  func touchIDSwitchValueChange(with status: Bool)
}

class SearchQRcodeOrTouchIDTableViewCell: UITableViewCell {

  lazy private var touchIDSwitch: UISwitch = {
    let view = UISwitch()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.tintColor = .pinkPeacock
    view.onTintColor = .pinkPeacock
    view.addTarget(self, action: #selector(touchIDSwitchValueChange(sender:)), for: .valueChanged)
    return view
  }()

  lazy private var titleImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.tintColor = .pinkPeacock
    return view
  }()

  lazy private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .pinkPeacock
    return label
  }()

  lazy private var bottomLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .defaultBackgroundColor
    return view
  }()

  var cellType: QRCodeOrTouchIDCellType = .touchID {
    didSet {
      titleLabel.text = cellType.title
      titleImageView.image = cellType.titleImage
      selectionStyle = cellType == .qrcode ? .default : .none
      touchIDSwitch.isHidden = cellType == .qrcode
      bottomLine.isHidden = cellType == .touchID
    }
  }

  var isOn: Bool? {
    didSet {
      guard let isOn = isOn else { return }
      touchIDSwitch.isOn = isOn
    }
  }

  weak var delegate: SearchQRcodeOrTouchIDCellDelegate?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    backgroundColor = .white
    contentView.addSubviews([titleImageView, titleLabel, touchIDSwitch, bottomLine])
    setUpLayout()
  }

  private func setUpLayout() {
    let views: [String: Any] = ["titleImageView": titleImageView, "titleLabel": titleLabel, "touchIDSwitch": touchIDSwitch, "bottomLine": bottomLine]

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[titleImageView]-5-|",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[titleLabel]-5-|",
      options: [],
      metrics: nil,
      views: views))

    NSLayoutConstraint.activate([
      touchIDSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[titleImageView(30)]-20-[titleLabel]-20-[touchIDSwitch(50)]-20-|",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[bottomLine]-10-|",
      options: [],
      metrics: nil,
      views: views))

    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[bottomLine(1)]|",
      options: [],
      metrics: nil,
      views: views))
  }

  // MARK: - Action Methods

  @objc private func touchIDSwitchValueChange(sender: UISwitch) {
    delegate?.touchIDSwitchValueChange(with: sender.isOn)
  }
}
