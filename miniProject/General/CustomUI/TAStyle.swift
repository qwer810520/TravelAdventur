//
//  TAStyle.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class TAStyle {
    
    typealias JSONDictionary = [String: Any]
    
    class var orange: UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.3960784314, blue: 0.2509803922, alpha: 1)
    }
    
    class var backgroundColor: UIColor {
        return #colorLiteral(red: 1, green: 0.8980392157, blue: 0.7058823529, alpha: 1)
    }
    
    class var navigationTitleFont: String {
        return "Avenir-Light"
    }
    
    class func dateToShowString(date:TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
}
