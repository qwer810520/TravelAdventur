//
//  AddPhotoButton.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class AddPhotoButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle("＋", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        self.backgroundColor = .pinkPeacock
        self.layer.cornerRadius = 35
    }
}
