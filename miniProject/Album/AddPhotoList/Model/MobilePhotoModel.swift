//
//  MobilePhotoModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct MobilePhotoModel {
    var image: UIImage
    var isSelect: Bool
    
    init(image: UIImage) {
        self.image = image
        self.isSelect = false
    }
}
