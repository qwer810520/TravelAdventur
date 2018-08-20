//
//  Album.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

struct Album {
    var albumID:String
    var travelName: String
    var startDate: Double
    var endDate: Double
    var titleImage: String
    var photos:Array<PhotoDataModel>
    
    init(albumID:String, travelName:String, startDate:Double, endDate:Double, titleImage:String, photos:Array<PhotoDataModel>) {
        self.albumID = albumID
        self.travelName = travelName
        self.startDate = startDate
        self.endDate = endDate
        self.titleImage = titleImage
        self.photos = photos
    }
}

