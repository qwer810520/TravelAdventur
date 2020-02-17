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

  @available(iOS 13, *)
  lazy private var albumFormatLayout: UICollectionViewLayout = {
    let layout = UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
      let width = self?.view.frame.width ?? 0.0

      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

      let item1 = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(0.3)))
      item1.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

      let subGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.3),
          heightDimension: .fractionalHeight(1.0)),
        subitem: item1,
        count: 2)

      let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(width * 0.6))
      let group1 = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item, subGroup])
      let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [subGroup, item])

      let parentGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .absolute(width),
          heightDimension: .absolute((width * 0.6) * 2)),
        subitems: [group1, group2])
      
      return NSCollectionLayoutSection(group: parentGroup)
    }
    return layout
  }()

  lazy private var showPhotosCollectionView: UICollectionView = {
    var layout: UICollectionViewLayout
    if #available(iOS 13, *) {
      layout = albumFormatLayout
    } else {
      layout = ShowPhotoFlowLayout()
    }
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
