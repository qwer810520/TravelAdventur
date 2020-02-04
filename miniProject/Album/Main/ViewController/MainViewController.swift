//
//  MainViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/14.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class MainViewController: ParentViewController {

  lazy private var mainView: MainView = {
    return MainView(delegate: self)
  }()

  private var presenter: MainPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = MainPresenter(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    setUserInterface()
  }

  // MARK: - Private Methods

  private func setUserInterface() {
    setNavigation(title: "Travel Adventur")
    view.addSubview(mainView)
    setUpLayout()
  }

  private func setUpLayout() {
    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[mainView]-tabbarHeight-|",
      options: [],
      metrics: ["tabbarHeight": tabbarHeight],
      views: ["mainView": mainView]))

    view.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[mainView]|",
      options: [],
      metrics: nil,
      views: ["mainView": mainView]))
  }
}

  // MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {
  func addAlbumButtonDidPressed() {
    print(#function)
    let addAlbunVC = TANavigationController(rootViewController: AddAlbunViewController())
    present(addAlbunVC, animated: true, completion: nil)
  }

  func getAlbumListCount() -> Int? {
    return presenter?.albumList.count ?? 0
  }

  func getAlbumInfo(with indexPath: IndexPath) -> AlbumModel? {
    return presenter?.getAlbumInfo(with: indexPath)
  }

  func didSelectItem(with indexPath: IndexPath) {
    let locationVC = LocationViewController()
    locationVC.selectAlbum = presenter?.getAlbumInfo(with: indexPath)
    navigationController?.pushViewController(locationVC, animated: true)
  }
}

  // MARK: - MainPresenterDelegate

extension MainViewController: MainPresenterDelegate {
  func refreshUI() {
    mainView.refreshUI()
  }

  func presentAlert(with title: String) {
    showAlert(title: title)
  }
}
