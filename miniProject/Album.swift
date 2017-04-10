//
//  Album.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
import UIKit
class Album {
    var key:String
    var travelName: String
    var time: String
    var day: String
    var titleImage: UIImage
    var photos:Array<PhotoDataModel>
    
    init(key:String, travelName:String, time:String, day:String, titleImage:UIImage, photos:Array<PhotoDataModel>) {
        self.key = key
        self.travelName = travelName
        self.time = time
        self.day = day
        self.titleImage = titleImage
        self.photos = photos
    }
}

