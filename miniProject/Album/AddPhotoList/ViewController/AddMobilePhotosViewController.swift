//
//  AddMobilePhotosViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import Photos

class AddMobilePhotosViewController: ParentViewController {

  lazy private var showMobilePhotoCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 2, height: (UIScreen.main.bounds.width / 3) - 2)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.dataSource = self
    view.delegate = self
    view.allowsMultipleSelection = true
    view.register(with: [ShowMobilePhotoCollectionViewCell.self])
    return view
  }()

  lazy private var addPhotoButton: AddPhotoButton = {
    let button = AddPhotoButton()
    button.addTarget(self, action: #selector(addPhotoButtonDidPressed), for: .touchUpInside)
    button.frame = CGRect(x: view.bounds.width - 70, y: view.frame.maxY, width: 50, height: 50)

    return button
  }()

  var placeData: PlaceModel?
  private var presenter: AddMobilePhotosPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = AddMobilePhotosPresenter(placeData: placeData ?? PlaceModel(), delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.queryPhotos()
    setUserInterface()
  }

  // MARK: - private Method

  private func setUserInterface() {
    setNavigation(title: "Add Photo", barButtonType: .dismiss_)
    view.addSubviews([showMobilePhotoCollectionView, addPhotoButton])
    setupAutoLayout()
  }

  private func setupAutoLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[collectionView]|",
      options: [],
      metrics: nil,
      views: ["collectionView": showMobilePhotoCollectionView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[collectionView]|",
      options: [],
      metrics: nil,
      views: ["collectionView": showMobilePhotoCollectionView]))
  }

  // MARK: - Action Method

  @objc private func addPhotoButtonDidPressed() {
    presenter?.uploadPhotoData()
  }
}

  // MARK: - UICollectionViewDelegate

extension AddMobilePhotosViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter?.didSelectItem(with: indexPath.item)
  }
}

  // MARK: - UICollectionViewDataSource

extension AddMobilePhotosViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter?.mobilePhotoList.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(with: ShowMobilePhotoCollectionViewCell.self, for: indexPath)
    cell.photoData = presenter?.mobilePhotoList[indexPath.row]
    return cell
  }
}

  // MARK: - AddMobilePhotosPresenterDelegate

extension AddMobilePhotosViewController: AddMobilePhotosPresenterDelegate {
  func addButtonIsHidden(fromStatus status: Bool) {
    let viewHeight = view.frame.height
    switch status {
      case true:
        guard addPhotoButton.frame.minY != viewHeight else { return }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
          self?.addPhotoButton.frame.origin.y = viewHeight
        })
      case false:
        guard addPhotoButton.frame.minY != viewHeight - 70 else { return }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
          self?.addPhotoButton.frame.origin.y = viewHeight - 70
        })
    }
  }

  func dismissVC() {
    dismiss(animated: true)
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func refreshUI() {
    DispatchQueue.main.async { [weak self] in
      self?.showMobilePhotoCollectionView.reloadData()
    }
  }
}
