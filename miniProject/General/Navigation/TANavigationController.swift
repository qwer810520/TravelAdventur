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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInterface()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        navigationBar.tintColor = .white
        navigationBar.barTintColor = TAStyle.orange
        navigationBar.backgroundColor = TAStyle.orange
        navigationBar.isTranslucent = true
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: TAStyle.navigationTitleFont, size: 24.0)!]
    }
}
