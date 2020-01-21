//
//  SearchPlaceViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/26.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchPlaceViewController: GMSAutocompleteViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        UINavigationBar.appearance().barTintColor = .pinkPeacock
        UINavigationBar.appearance().tintColor = .white
        tableCellSeparatorColor = .pinkPeacock
        tableCellBackgroundColor = .white
        tintColor = .white
        primaryTextColor = .lightGray
        primaryTextHighlightColor = .pinkPeacock
    }
}
