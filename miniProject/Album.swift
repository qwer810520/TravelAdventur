//
//  Album.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
class Album {
    var travelName: String
    var time: String
    var day: String
    var titleImage: String
    var photos: [PhotoDataModel]
    
    init(travelName:String, time:String, day:String, titleImage:String, photos:[PhotoDataModel]) {
        self.travelName = travelName
        self.time = time
        self.day = day
        self.titleImage = titleImage
        self.photos = photos
    }
    
}
