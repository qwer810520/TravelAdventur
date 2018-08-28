//
//  TATabbarController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

enum TATabbarItem {
    case Album
    case User
}

class TATabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbar()
        setTabbarItem()
        selectItem(item: .Album)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - private Method
    
    private func setTabbar() {
        self.delegate = self
        tabBar.isTranslucent = true
        tabBar.barTintColor = TAStyle.orange
        tabBar.backgroundColor = TAStyle.orange
        tabBar.tintColor = .white
    }
    
    private func setTabbarItem() {
        let albumVC = TANavigationController(rootViewController: MainViewController())
        albumVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "photoalbum"), tag: TATabbarItem.Album.hashValue)
        
        let userVC = TANavigationController(rootViewController: UserMainViewController())
        userVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbarIcon_User"), tag: TATabbarItem.User.hashValue)
        
        self.viewControllers = [albumVC, userVC]
    }
    
    func selectItem(item: TATabbarItem) {
        switch item {
        case .Album:
            selectedIndex = item.hashValue
        case .User:
            selectedIndex = item.hashValue
        }
    }
}

    // NARK: - UITabBarControllerDelegate

extension TATabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
