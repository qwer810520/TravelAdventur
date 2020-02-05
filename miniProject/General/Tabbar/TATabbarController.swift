//
//  TATabbarController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

enum TATabbarItem {
  case album, user
}

class TATabbarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setTabbar()
    setTabbarItem()
    selectItem(item: .album)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - private Method

  private func setTabbar() {
    delegate = self
    tabBar.unselectedItemTintColor = UIColor(r: 82, g: 82, b: 82, a: 100)
    tabBar.tintColor = .pinkPeacock
  }

  private func setTabbarItem() {
    let albumVC = TANavigationController(rootViewController: MainViewController())
    albumVC.tabBarItem = UITabBarItem(title: "Album", image: "tabbar_album_deselect_icon".toImage, selectedImage: "tabbar_album_select_icon".toImage)
    albumVC.tabBarItem.tag = TATabbarItem.album.hashValue

    let userVC = TANavigationController(rootViewController: UserMainViewController())
    userVC.tabBarItem = UITabBarItem(title: "User", image: "tabbar_user_deselect_icon".toImage, selectedImage: "tabbar_user_select_icon".toImage)
    userVC.tabBarItem.tag = TATabbarItem.user.hashValue

    viewControllers = [albumVC, userVC]
  }

  func selectItem(item: TATabbarItem) {
    switch item {
      case .album:
        selectedIndex = item.hashValue
      case .user:
        selectedIndex = item.hashValue
    }
  }
}

// NARK: - UITabBarControllerDelegate

extension TATabbarController: UITabBarControllerDelegate {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

  }
}
