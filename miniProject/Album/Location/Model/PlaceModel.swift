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
  var time: TimeInterval
  var latitude: Double
  var longitude: Double
  var isMark: Bool
  var photoList: [String]

  init() {
    self.albumID = ""
    self.placeID = ""
    self.name = ""
    self.time = 0.0
    self.latitude = 0.0
    self.longitude = 0.0
    self.isMark = false
    self.photoList = [String]()
  }

  init(json: JSONDictionary) {
    self.albumID = (json["albumID"] as? String) ?? ""
    self.placeID = (json["placeID"] as? String) ?? ""
    self.name = (json["name"] as? String) ?? ""
    self.time = (json["time"] as? TimeInterval) ?? 0.0
    self.latitude = (json["latitude"] as? Double) ?? 0.0
    self.longitude = (json["longitude"] as? Double) ?? 0.0
    self.photoList = (json["photoList"] as? [String]) ?? [String]()
    self.isMark = false
  }
}
