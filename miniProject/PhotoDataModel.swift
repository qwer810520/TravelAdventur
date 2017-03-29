//
//  PhotoDataModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/27.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//
import UIKit
import Foundation
import MapKit

class PhotoDataModel {
//    var name:String
    var photoName: Array<String>
    var picturesDay: String
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    
    init(photoName: Array<String>, picturesDay:String, latitude: CLLocationDegrees, longitude:CLLocationDegrees) {
        self.photoName = photoName
        self.picturesDay = picturesDay
        self.latitude = latitude
        self.longitude = longitude
    }
}
