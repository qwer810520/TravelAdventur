//
//  AlbumModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct AddAlbumModel {
    var title: String
    var startTime: Double
    var endTime: Double
    var titlePhoto: UIImage
    
    init() {
        self.title = ""
        self.startTime = 0.0
        self.endTime = 0.0
        self.titlePhoto = UIImage()
    }
}
