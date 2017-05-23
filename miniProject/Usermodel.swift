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
    var participateAlbum:Array<String>?
    var setActivity:Array<String>?
    var participateActivity:Array<String>?
    
    init(userId:String, participateAlbum:Array<String>, setActivity:Array<String>, participateActivity:Array<String>) {
        self.userId = userId
        self.participateAlbum = participateAlbum
        self.setActivity = setActivity
        self.participateAlbum = participateAlbum
    }
}
