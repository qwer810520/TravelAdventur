//
//  TABarButtonItem.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/20.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class TABarButtonItem {
    
    class func setImageBarButtonItem(imageName: String, target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: target, action: action)
    }
    
    class func setAddBarButton(target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: target, action: action)
    }
    
    class func setTitleBarButtonItem(title: String, target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: target, action: action)
    }
}
