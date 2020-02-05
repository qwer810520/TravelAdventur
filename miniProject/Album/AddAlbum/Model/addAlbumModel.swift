//
//  AlbumModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct AddAlbumModel {
  var id: String
  var title: String
  var startTime: Double
  var day: Int
  var coverPhoto: UIImage?

  init() {
    self.id = ""
    self.title = ""
    self.startTime = Date().timeIntervalSince1970
    self.day = 1
    self.coverPhoto = nil
  }

  func checkFormatter() throws {
    guard !title.isEmpty else {
      throw TAError.other("請輸入相簿名稱")
    }

    guard coverPhoto != nil else {
      throw TAError.other("請選擇封面相片")
    }
  }
}
