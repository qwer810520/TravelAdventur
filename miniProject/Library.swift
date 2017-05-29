//
//  Library.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/5/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class Library {
    
    static func dateToShowString(date:TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
    
    static func endDateToShowString(date:TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd日"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
    
    static func AlertSet(title: String, message:String, controllerType:UIAlertControllerStyle, checkButton1:String, checkButton1Type:UIAlertActionStyle, button2switch:Bool, checkButton2:String?, checkButton2Type:UIAlertActionStyle?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: controllerType)
        alert.addAction(UIAlertAction(title: checkButton1, style: checkButton1Type, handler: nil))
        if button2switch == true {
            alert.addAction(UIAlertAction(title: checkButton2, style: checkButton2Type!, handler: nil))
        }
        return alert
    }
    
    static func isInternetOk() -> Bool {
        let reachability = Reachability(hostName: "https://www.apple.com/tw/")
        if reachability?.currentReachabilityStatus().rawValue == 0 {
            return false
        } else {
            return true
        }
    }
}
