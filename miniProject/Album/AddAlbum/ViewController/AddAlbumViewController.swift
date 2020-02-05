//
//  AddViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/8.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class AddAlbumViewController: ParentViewController {

  lazy private var addAlbumView: AddAlbumBackgroundView = {
    return AddAlbumBackgroundView(dayOptionList: Array(1...30), delegate: self)
  }()

  private var presenter: AddAlbumPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AddAlbumPresenter(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterface()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  // MARK: - Private Method

  private func setUserInterface() {
    setNavigation(title: "Add Album", barButtonType: .dismiss_)
    view.addSubview(addAlbumView)
    setUpNotification()
    setUpLayout()
    refreshUI()
  }

  private func setUpLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[addAlbumView]|",
      options: [],
      metrics: nil,
      views: ["addAlbumView": addAlbumView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[addAlbumView]|",
      options: [],
      metrics: nil,
      views: ["addAlbumView": addAlbumView]))
  }

  private func setUpNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func resetAddAlbumViewFrame() {
    guard addAlbumView.frame.origin.y != 0 else { return }
    addAlbumView.frame.origin.y = 0
  }

  // MARK: - Action Methods

  @objc private func keyboardWillShow(notification: Notification) {
      if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
        switch addAlbumView.didEditingTextFieldType {
          case .day:
            guard addAlbumView.inputBackgroundView.frame.maxY > (addAlbumView.frame.height - height) else { return }
            addAlbumView.frame.origin.y = -(addAlbumView.inputBackgroundView.frame.maxY - (addAlbumView.frame.height - height))
            view.layoutIfNeeded()
          default:
            resetAddAlbumViewFrame()
        }
      }
  }

  @objc private func keyBoardWillHidden(notification: Notification) {
    resetAddAlbumViewFrame()
  }
}

// MARK: - AddAlbumDelegate

extension AddAlbumViewController: AddAlbumDelegate {
  func addAlbumCoverPhotoButtonDidPressed() {
    view.endEditing(true)
    presenter?.checkAlbumAuthority()
  }

  func nameTextFieldEditingChanged(with text: String) {
    presenter?.setAlbumName(with: text)
  }

  func didSelectDateOption(with date: TimeInterval) {
    presenter?.setAlbumStartDate(with: date)
  }

  func didSelectDateDay(with day: Int) {
    presenter?.setAlbumDayRange(with: day)
  }

  func addAlbumButtonDidPressed() {
    presenter?.addAlnum()
  }
}

  // MARK: - AddAlbumPresenterDelegate

extension AddAlbumViewController: AddAlbumPresenterDelegate {
  func presentImagePickerVC() {
    DispatchQueue.main.async { [weak self] in
      UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
      let imagePicker = UIImagePickerController()
      imagePicker.allowsEditing = false
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      self?.present(imagePicker, animated: true, completion: nil)
    }
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func refreshUI() {
    addAlbumView.setAlbumInfo(with: presenter?.addAlbum ?? AddAlbumModel())
  }

  func dismissVC() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UIImagePickerControllerDelegate

extension AddAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let picture = info[.originalImage] as? UIImage {
      presenter?.setAlbumCoverImage(with: picture)
    }
    dismissVC()
  }
}
