//
//  PlaceModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct PlaceModel {
    var albumID: String
    var placeID: String
    var name: String
    var time: Double
    var latitude: Double
    var longitude: Double
    var isMark: Bool
    var photoList: [String]
    
    init(json: TAStyle.JSONDictionary) {
        self.albumID = (json["albumID"] as? String) ?? ""
        self.placeID = (json["placeID"] as? String) ?? ""
        self.name = (json["name"] as? String) ?? ""
        self.time = (json["time"] as? Double) ?? 0.0
        self.latitude = (json["latitude"] as? Double) ?? 0.0
        self.longitude = (json["longitude"] as? Double) ?? 0.0
        self.isMark = false
        
        guard let photoData = json["photoList"] as? [String] else {
            self.photoList = [String]()
            return
        }
        self.photoList = photoData
    }
}
