//
//  Usermodel.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/5/23.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import Foundation
import UIKit

class UserModel {
    var userId:String?
    var participateAlbum:Dictionary<String,String>?
    var setActivity:Dictionary<String,String>?
    var participateActivity:Dictionary<String,String>?
    
    init(userId:String, participateAlbum:Dictionary<String,String>?, setActivity:Dictionary<String,String>?, participateActivity:Dictionary<String,String>?) {
        self.userId = userId
        self.participateAlbum = participateAlbum
        self.setActivity = setActivity
        self.participateAlbum = participateAlbum
    }
}
