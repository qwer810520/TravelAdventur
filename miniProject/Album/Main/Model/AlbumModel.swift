//
//  AlbumModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/24.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct AlbumModel {
    var id: String
    var title: String
    var startTime: TimeInterval
    var day: Int
    var coverPhotoURL: String
    
    init() {
        self.id = ""
        self.title = ""
        self.startTime = 0.0
        self.day = 0
        self.coverPhotoURL = ""
    }
    
    init(json: JSONDictionary) {
        self.id = (json["id"] as? String) ?? ""
        self.title = (json["title"] as? String) ?? ""
        self.startTime = (json["startTime"] as? TimeInterval) ?? 0.0
        self.day = (json["day"] as? Int) ?? 0
        self.coverPhotoURL = (json["coverPhotoURL"] as? String) ?? ""
    }
}
