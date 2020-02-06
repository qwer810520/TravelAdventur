//
//  AddLocationView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GooglePlaces

protocol AddPlaceDelegate: class {
  func addPlaceButtonDidPressed()
  func placeTextFieldEditingBegin()
  func didSelectDate(with date: TimeInterval)
}

class AddPlaceView: UIView {

  lazy private var inputBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layer.shadowOffset = CGSize(width: 5, height: 5)
    view.layer.shadowOpacity = 0.3
    view.layer.shadowRadius = 10
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.cornerRadius = 5
    return view
  }()

  lazy private var placeInputTextField: AddPlaceInputView = {
    return AddPlaceInputView(viewType: .place, delegate: self)
  }()

  lazy private var dateInputTextField: AddPlaceInputView = {
    return AddPlaceInputView(viewType: .date, delegate: self)
  }()

  lazy private var addButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add", for: .normal)
    button.titleLabel?.font = .navigationTitleFont
    button.tintColor = .white
    button.layer.cornerRadius = 10
    button.backgroundColor = .pinkPeacock
    button.addTarget(self, action: #selector(addPlaceButtonDidPressed), for: .touchUpInside)
    return button
  }()

  weak var delegate: AddPlaceDelegate?

  // MARK: - Initialization

  init(delegate: AddPlaceDelegate? = nil) {
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setInfo(with albumInfo: AlbumModel, placeInfo: AddPlaceModel) {
    placeInputTextField.setInfo(with: albumInfo, placeInfo: placeInfo)
    dateInputTextField.setInfo(with: albumInfo, placeInfo: placeInfo)
  }

  // MARK: - Private method

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    addSubviews([inputBackgroundView, addButton])
    inputBackgroundView.addSubviews([placeInputTextField, dateInputTextField])
    setUpAutoLayout()
  }

  private func setUpAutoLayout() {
    let views: [String: Any] = ["inputBackgroundView": inputBackgroundView, "addButton": addButton, "placeInputTextField": placeInputTextField, "dateInputTextField": dateInputTextField]

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[placeInputTextField]|",
      options: [],
      metrics: nil,
      views: views))

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[dateInputTextField]|",
      options: [],
      metrics: nil,
      views: views))

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[placeInputTextField(==dateInputTextField)][dateInputTextField(==placeInputTextField)]-5-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[inputBackgroundView]-20-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[addButton]-20-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-20-[inputBackgroundView(130)]-40-[addButton(40)]",
      options: [],
      metrics: nil,
      views: views))
  }

  // MARK: - Action methods

  @objc private func addPlaceButtonDidPressed() {
    guard let delegate = delegate else { return }
    delegate.addPlaceButtonDidPressed()
  }
}

  // MARK: - AddPlaceInputDelegate

extension AddPlaceView: AddPlaceInputDelegate {
  func placeTextFieldEditingBegin() {
    delegate?.placeTextFieldEditingBegin()
  }

  func didSelectDate(with date: TimeInterval) {
    delegate?.didSelectDate(with: date)
  }
}
