//
//  TANavigationController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class TANavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    
    private func setUserInterface() {
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(createImage(from: CGSize(width: navigationBar.frame.width, height: 64), with: .pinkPeacock), for: .default)

        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.navigationTitleFont]
    }
}
