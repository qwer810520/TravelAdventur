//
//  Usermodel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/5/23.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
import UIKit

struct UserModel {
    var userId:String?
    var userName:String?
    var userPhoto:String?
    var participateAlbum:Dictionary<String,String>?
    var setActivity:Dictionary<String,String>?
    var participateActivity:Dictionary<String,String>?
    
    init(userId:String, userName:String, userPhoto:String, participateAlbum:Dictionary<String,String>?, setActivity:Dictionary<String,String>?, participateActivity:Dictionary<String,String>?) {
        self.userId = userId
        self.userName = userName
        self.userPhoto = userPhoto
        self.participateAlbum = participateAlbum
        self.setActivity = setActivity
        self.participateAlbum = participateAlbum
    }
}
