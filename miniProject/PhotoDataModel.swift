//
//  PhotoDataModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/27.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//
import UIKit
import Foundation
import GoogleMaps

class PhotoDataModel {
    var albumID:String
    var photoID:String
    var locationName:String
    var photoName: Array<String>
    var picturesDay: Double
    var coordinate:CLLocationCoordinate2D
    var selectSwitch:Bool
    
    init(albumID:String, photoID:String,locationName:String, photoName: Array<String>, picturesDay:Double, coordinate:CLLocationCoordinate2D, selectSwitch:Bool) {
        self.albumID = albumID
        self.photoID = photoID
        self.locationName = locationName
        self.photoName = photoName
        self.picturesDay = picturesDay
        self.coordinate = coordinate
        self.selectSwitch = selectSwitch
    }
}

class modelPhotosData {
    var image:UIImage
    var bool:Bool
    
    init(image:UIImage, bool:Bool) {
        self.image = image
        self.bool = bool
    }
}



