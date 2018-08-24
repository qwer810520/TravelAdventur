//
//  LocationViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationViewController: ParentViewController {
    
    var selectAlnum: AlbumModel?
    
    lazy var segmented: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Place", "Shared Album"])
        view.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 30)
        view.tintColor = .white
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentedValueChanged(sender:)), for: .valueChanged)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInterFace()
    }
    
    // MARK: - private Method
    
    private func setUserInterFace() {
        setNavigation(title: nil, barButtonType: .Back_Add)
        navigationItem.titleView = segmented
    }
    
    // MARK: - Action Method
    
    @objc private func segmentedValueChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
