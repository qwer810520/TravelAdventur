//
//  activity.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/25.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//
import UIKit

class activity {
    var user = ""
    var activityName = ""
    var time = ""
    var message = ""
    var address = ""
    
    init(user:String, activityName:String, time:String, message:String, address:String) {
        self.user = user
        self.activityName = activityName
        self.time = time
        self.message = message
        self.address = address
    }
    
}
