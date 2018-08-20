//
//  LoginUserModel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/16.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

struct LoginUserModel {
    var uid: String
    var name: String
    var photoURL: String
    var albumIdList: [String]
    
    init(uid: String, name: String, photoURL: String) {
        self.uid = uid
        self.name = name
        self.photoURL = photoURL
        self.albumIdList = [String]()
    }
    
    init(json: TAStyle.JSONDictionary) {
        self.uid = (json["uid"] as? String) ?? ""
        self.name = (json["userName"] as? String) ?? ""
        self.photoURL = (json["userPhoto"] as? String) ?? ""
        guard let userAlbumIdList = json["albumIdList"] as? [String] else {
            self.albumIdList = [String]()
            return
        }
        var idList = [String]()
        userAlbumIdList.forEach { idList.append($0) }
        self.albumIdList = idList
    }
}
