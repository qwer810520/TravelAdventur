//
//  LocationSegmented.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol LocationSegmentedValueChange: class {
    func LocationSegmentedValueChange(value: Int)
}

class LocationSegmented: UISegmentedControl {
    weak var delegate: LocationSegmentedValueChange?
    
    init(delegate: LocationSegmentedValueChange? = nil ) {
        self.delegate = delegate
        super.init(items: ["Place", "Shared Album"])
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.selectedSegmentIndex = 0
        self.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 30)
        self.addTarget(self, action: #selector(segmentedValueChange(sender:)), for: .valueChanged)
    }
    
    // MARK: - Action Method
    
    @objc private func segmentedValueChange(sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        delegate.LocationSegmentedValueChange(value: sender.selectedSegmentIndex)
    }
}
