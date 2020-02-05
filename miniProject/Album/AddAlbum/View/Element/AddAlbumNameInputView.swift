//
//  AddAlbumInputView.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol AddAlbumNameInputDelegate: class {
  func nameInputTextFieldEditingChanged(with text: String)
  func nameInputEditingBegin()
}

class AddAlbumNameInputView: UIView {

  weak var delegate: AddAlbumNameInputDelegate?

  lazy private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "相簿名稱"
    return label
  }()

  lazy private var nameInputTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderStyle = .none
    textField.tintColor = .pinkPeacock
    textField.placeholder = "請輸入行程名稱"
    textField.addTarget(self, action: #selector(nameInputTextFieldEditingChanged(_:)), for: .editingChanged)
    textField.delegate = self
    return textField
  }()

  lazy private var bottomLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray_A30
    return view
  }()

  init(delegate: AddAlbumNameInputDelegate? = nil) {
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews([titleLabel, nameInputTextField, bottomLine])
    setUpLayout()
  }

  private func setUpLayout() {
    let views: [String: Any] = ["titleLabel": titleLabel, "nameInputTextField": nameInputTextField, "bottomLine": bottomLine]

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[titleLabel]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[nameInputTextField]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[bottomLine]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[titleLabel(15)]-5-[nameInputTextField][bottomLine(1)]|",
      options: [],
      metrics: nil,
      views: views))
  }

  // MARK: - Action Methods

  @objc private func nameInputTextFieldEditingChanged(_ textField: UITextField) {
    delegate?.nameInputTextFieldEditingChanged(with: textField.text ?? "")
  }
}

  // MARK: - UITextFieldDelegate

extension AddAlbumNameInputView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.nameInputEditingBegin()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
