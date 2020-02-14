//
//  ShowPhotoListViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowPhotoListViewController: ParentViewController {

  var placeData: PlaceModel?
  private var presenter: ShowPhotoListPresenter?

  lazy private var showPhotosCollectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: ShowPhotoFlowLayout())
    view.translatesAutoresizingMaskIntoConstraints = false
    view.dataSource = self
    view.backgroundColor = .clear
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    view.register(with: [ShowPhotosCollectionViewCell.self])
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = ShowPhotoListPresenter(placeInfo: placeData ?? PlaceModel(), delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserUnterface()
  }

  // MARK: - Private Methods

  private func setUserUnterface() {
    setNavigation(title: "Photos", barButtonType: .back_addPhoto)
    view.addSubview(showPhotosCollectionView)
    setUpAutoLayout()
    presenter?.getPhotoList()
  }

  private func setUpAutoLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[collectionView]|",
      options: [],
      metrics: nil,
      views: ["collectionView": showPhotosCollectionView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[collectionView]|",
      options: [],
      metrics: nil,
      views: ["collectionView": showPhotosCollectionView]))
  }

  // MARK: - Action Method

  override func addButtonDidPressed() {
    let addMobileVC = AddMobilePhotosViewController()
    addMobileVC.placeData = presenter?.placeInfo
    let addMobileNavigaiton = TANavigationController(rootViewController: addMobileVC)
    present(addMobileNavigaiton, animated: true, completion: nil)
  }
}

  // MARK: - UICollectionViewDataSource

extension ShowPhotoListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter?.photoURLList.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(with: ShowPhotosCollectionViewCell.self, for: indexPath)
    cell.imageURL = presenter?.photoURLList[indexPath.row]
    return cell
  }
}

  // MARK: - ShowPhotoListPresenterDelegate

extension ShowPhotoListViewController: ShowPhotoListPresenterDelegate {
  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }

  func refreshUI() {
    showPhotosCollectionView.reloadData()
  }
}
