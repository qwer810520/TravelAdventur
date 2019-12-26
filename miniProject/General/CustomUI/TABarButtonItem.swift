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
    
    class func setDismissButton(target: Any, action: Selector) -> UIBarButtonItem {
        let buttonLeft = UIButton()
        buttonLeft.setImage(UIImage(named: "cross"), for: .normal)
        buttonLeft.addTarget(target, action: action, for: .touchUpInside)
        if #available(iOS 11, *) {
            buttonLeft.widthAnchor.constraint(equalToConstant: 20).isActive = true
            buttonLeft.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            buttonLeft.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        return UIBarButtonItem(customView: buttonLeft)
    }
    
    class func setAddBarButton(target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: target, action: action)
    }
    
    class func setTitleBarButtonItem(title: String, target: Any?, action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: target, action: action)
    }
}
