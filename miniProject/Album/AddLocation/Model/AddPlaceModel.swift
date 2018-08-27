//
//  AddPlaceModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/26.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct AddPlaceModel {
    var placeName: String
    var latitude: Double
    var longitude: Double
    var time: Double
    
    init() {
        self.placeName = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.time = 0.0
    }
}
