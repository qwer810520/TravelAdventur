//
//  AlbumModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct AddAlbumModel {
    var id: String
    var title: String
    var startTime: Double
    var day: Int
    var coverPhoto: UIImage?
    
    init() {
        self.id = ""
        self.title = ""
        self.startTime = 0.0
        self.day = 0
        self.coverPhoto = nil
    }
}
