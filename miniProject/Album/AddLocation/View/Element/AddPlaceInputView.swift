//
//  AddPlaceInputView.swift
//  miniProject
//
//  Created by Min on 2020/2/6.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit
import GooglePlaces

enum AddPlaceInputType {
  case place, date
}

extension AddPlaceInputType {
  var title: String {
    switch self {
      case .place:
        return "拍照地點"
      case .date:
        return "拍照日期"
    }
  }
}

protocol AddPlaceInputDelegate: class {
  func placeTextFieldEditingBegin()
  func didSelectDate(with date: TimeInterval)
}

class AddPlaceInputView: UIView {

  lazy private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  lazy private var inputTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderStyle = .none
    textField.tintColor = .pinkPeacock
    return textField
  }()

  lazy private var bottomLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray_A30
    return view
  }()

  lazy private var datePickerView: UIDatePicker = {
      let datePicker = UIDatePicker()
      datePicker.datePickerMode = .date
      datePicker.locale = Locale(identifier: "Chinese")
      return datePicker
  }()

  private(set) var viewType: AddPlaceInputType
  weak var delegate: AddPlaceInputDelegate?

  init(viewType: AddPlaceInputType, delegate: AddPlaceInputDelegate? = nil) {
    self.viewType = viewType
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  func setInfo(with albumInfo: AlbumModel, placeInfo: AddPlaceModel) {
    switch viewType {
      case .place:
        inputTextField.text = placeInfo.placeName
      case .date:
        inputTextField.text = placeInfo.time.dateToString(type: .all)
        datePickerView.date = Date(timeIntervalSince1970: placeInfo.time)
        datePickerView.minimumDate = Date(timeIntervalSince1970: albumInfo.startTime)
        datePickerView.maximumDate = Date(timeIntervalSince1970: albumInfo.startTime.calculationEndTimeInterval(with: albumInfo.day))
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews([titleLabel, inputTextField, bottomLine])
    setUpLayout()
    titleLabel.text = viewType.title
    bottomLine.isHidden = viewType == .date
    setUpTextField()
  }

  private func setUpLayout() {
    let views: [String: Any] = ["titleLabel": titleLabel, "inputTextField": inputTextField, "bottomLine": bottomLine]

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[titleLabel]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[inputTextField]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[bottomLine]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[titleLabel(15)]-5-[inputTextField][bottomLine(1)]|",
      options: [],
      metrics: nil,
      views: views))
  }

  private func setUpTextField() {
    switch viewType {
      case .place:
        inputTextField.tintColor = .pinkPeacock
        inputTextField.addTarget(self, action: #selector(inputTextFieldEditingBegin), for: .editingDidBegin)
      case .date:
        inputTextField.inputView = datePickerView
        inputTextField.inputView?.backgroundColor = .white
        inputTextField.tintColor = .clear
        inputTextField.inputAccessoryView = TAToolBar(cancelAction: { [weak self] in
          self?.inputTextField.resignFirstResponder()
        }, checkAction: { [weak self] in
          self?.delegate?.didSelectDate(with: self?.datePickerView.date.timeIntervalSince1970 ?? 0.0)
          self?.inputTextField.resignFirstResponder()
        })
    }
  }

  // MARK: - Action Methods

  @objc private func inputTextFieldEditingBegin() {
    guard viewType == .place else { return }
    delegate?.placeTextFieldEditingBegin()
  }
}
