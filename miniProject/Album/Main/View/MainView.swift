//
//  MainView.swift
//  miniProject
//
//  Created by Min on 2020/2/4.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

protocol MainViewDelegate: class {
  func getAlbumListCount() -> Int?
  func getAlbumInfo(with indexPath: IndexPath) -> AlbumModel?
  func didSelectItem(with indexPath: IndexPath)
  func addAlbumButtonDidPressed()
}

class MainView: UIView {

  lazy private var collectionView: UICollectionView = {
    let layout = StickyCollectionViewFlowLayout()
    layout.firstItemTransform = 0.05
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: (UIScreen.main.bounds.width - 60) * 0.8375)
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(ShowAlbumDetailCollectionViewCell.self, forCellWithReuseIdentifier: ShowAlbumDetailCollectionViewCell.identifier)
    view.backgroundColor = .clear
    view.delegate = self
    view.dataSource = self
    return view
  }()

  lazy private var addAlbumButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage("Main_addAlbumBtn_Icon".toImage, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.addTarget(self, action: #selector(addButtonDidPressed), for: .touchUpInside)
    button.layer.cornerRadius = 20
    button.layer.shadowOffset = CGSize(width: 5, height: 5)
    button.layer.shadowOpacity = 0.6
    button.layer.shadowRadius = 5
    button.layer.shadowColor = UIColor.lightGray.cgColor
    return button
  }()

  weak var delegate: MainViewDelegate?

  init(delegate: MainViewDelegate? = nil) {
    self.delegate = delegate
    super.init(frame: .zero)
    setUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func refreshUI() {
    collectionView.reloadData()
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    addSubviews([collectionView, addAlbumButton])
    setUpLayout()
  }

  private func setUpLayout() {
    let views: [String: Any] = ["collectionView": collectionView, "addAlbumButton": addAlbumButton]

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[collectionView]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[collectionView]|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[addAlbumButton(50)]-10-|",
      options: [],
      metrics: nil,
      views: views))

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:[addAlbumButton(50)]-10-|",
      options: [],
      metrics: nil,
      views: views))

  }

  // MARK: - Action Methods

  @objc private func addButtonDidPressed() {
    delegate?.addAlbumButtonDidPressed()
  }
}

  // MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectItem(with: indexPath)
  }
}

  // MARK: - UICollectionViewDataSource

extension MainView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return delegate?.getAlbumListCount() ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(with: ShowAlbumDetailCollectionViewCell.self, for: indexPath)
    cell.albumModel = delegate?.getAlbumInfo(with: indexPath)
    return cell
  }
}
