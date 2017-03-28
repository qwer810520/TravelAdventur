//
//  PhotoDataModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/27.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
import MapKit

class PhotoDataModel {
    var name: String
    var day: String
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    
    init(name:String, day:String, longitude:CLLocationDegrees, latitude: CLLocationDegrees) {
        self.name = name
        self.day = day
        self.longitude = longitude
        self.latitude = latitude
    }
}
