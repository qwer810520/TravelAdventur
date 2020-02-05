//
//  AddAlbumBackgroundView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol AddAlbumDelegate: class {
  func addAlbumButtonDidPressed()
  func nameTextFieldEditingChanged(with text: String)
  func didSelectDateOption(with date: TimeInterval)
  func didSelectDateDay(with day: Int)
  func addAlbumCoverPhotoButtonDidPressed()
}

class AddAlbumBackgroundView: UIView {

  lazy private var addAlbumCoverPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(nil, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.layer.cornerRadius = 5
    button.layer.shadowOffset = CGSize(width: 5, height: 5)
    button.layer.shadowOpacity = 0.3
    button.layer.shadowRadius = 10
    button.layer.shadowColor = UIColor.black.cgColor
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(addAlbumCoverPhotoButtonDidPressed), for: .touchUpInside)
    return button
  }()

  lazy private(set) var inputBackgroundView: UIView = {
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

  lazy private var nameInputTextField: AddAlbumNameInputView = {
     return AddAlbumNameInputView(delegate: self)
   }()

   lazy private(set) var dateInputTextField: AddAlbumDateOptionView = {
     return AddAlbumDateOptionView(type: .date, dayOptionList: [], delegate: self)
   }()

   lazy private(set) var dayInputTextFidld: AddAlbumDateOptionView = {
     return AddAlbumDateOptionView(type: .day, dayOptionList: dayOptionList, delegate: self)
   }()

   lazy private var addButton: UIButton = {
     let button = UIButton(type: .system)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.setTitle("Add", for: .normal)
     button.titleLabel?.font = .navigationTitleFont
     button.tintColor = .white
     button.layer.cornerRadius = 5
     button.backgroundColor = .pinkPeacock
     button.addTarget(self, action: #selector(addAlbumButtonDidPressed), for: .touchUpInside)
     return button
   }()

  weak var delegate: AddAlbumDelegate?
  private(set) var didEditingTextFieldType: AddAlbumDateType = .none
  private var dayOptionList = [Int]()

  init(dayOptionList: [Int], delegate: AddAlbumDelegate? = nil) {
    self.dayOptionList = dayOptionList
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setAlbumInfo(with info: AddAlbumModel) {
    dateInputTextField.setInfo(with: info)
    dayInputTextFidld.setInfo(with: info)
    switch info.coverPhoto {
      case .some(let image):
        addAlbumCoverPhotoButton.setImage(nil, for: .normal)
        addAlbumCoverPhotoButton.setBackgroundImage(image, for: .normal)
      case .none:
        addAlbumCoverPhotoButton.setImage("addAlbum_albumCover_Icon".toImage, for: .normal)
        addAlbumCoverPhotoButton.setBackgroundImage(nil, for: .normal)
    }
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    setAutoLayout()
  }

  private func setAutoLayout() {
    addSubviews([inputBackgroundView, addButton, addAlbumCoverPhotoButton])

    inputBackgroundView.addSubviews([nameInputTextField, dateInputTextField, dayInputTextFidld])

    let views: [String: Any] = ["addAlbumCoverPhotoButton": addAlbumCoverPhotoButton, "backgroundView": inputBackgroundView, "addButton": addButton, "nameInputTextField": nameInputTextField, "dateInputTextField": dateInputTextField, "dayInputTextFidld": dayInputTextFidld]

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[nameInputTextField]|",
      options: [],
      metrics: nil,
      views: views))

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[dateInputTextField]|",
      options: [],
      metrics: nil,
      views: views))

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[dayInputTextFidld]|",
      options: [],
      metrics: nil,
      views: views))

    inputBackgroundView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-5-[nameInputTextField(==dayInputTextFidld)][dateInputTextField(==nameInputTextField)][dayInputTextFidld(==dateInputTextField)]-5-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[addAlbumCoverPhotoButton]-20-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[backgroundView]-20-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[addButton]-20-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-20-[addAlbumCoverPhotoButton(180)]-20-[backgroundView(195)]-40-[addButton(40)]",
      options: [],
      metrics: nil,
      views: views))

  }

  // MARK: - Action Method

  @objc private func addAlbumButtonDidPressed() {
    guard let delegate = delegate else { return }
    delegate.addAlbumButtonDidPressed()
  }

  @objc private func addAlbumCoverPhotoButtonDidPressed() {
    delegate?.addAlbumCoverPhotoButtonDidPressed()
  }
}

  // MARK: - AddAlbumNameInputDelegate

extension AddAlbumBackgroundView: AddAlbumNameInputDelegate {
  func nameInputEditingBegin() {
    didEditingTextFieldType = .none
  }

  func nameInputTextFieldEditingChanged(with text: String) {
    delegate?.nameTextFieldEditingChanged(with: text)
  }
}

  // MARK: - AddAlbumDateOptionDelegate

extension AddAlbumBackgroundView: AddAlbumDateOptionDelegate {
  func textFieldEditingDidBegin(with type: AddAlbumDateType) {
    didEditingTextFieldType = type
  }

  func didSelectDateOption(with date: TimeInterval) {
    delegate?.didSelectDateOption(with: date)
  }

  func didSelectDayOption(with day: Int) {
    delegate?.didSelectDateDay(with: day)
  }
}
