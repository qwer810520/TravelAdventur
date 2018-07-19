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
    
    // MARK: - private Method
    
    private func setUserInterface() {
        navigationBar.tintColor = .white
        navigationBar.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.2901960784, blue: 0.1287725311, alpha: 1)
        navigationBar.barTintColor = nil
        
    }
}
