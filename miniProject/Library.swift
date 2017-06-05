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
    static func alertSet(title: String, message:String, controllerType:UIAlertControllerStyle, checkButton1:String, checkButton1Type:UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: controllerType)
        alert.addAction(UIAlertAction(title: checkButton1, style: checkButton1Type, handler: handler))
        return alert
    }
    
    static func twoAlertSet(title: String, message:String, controllerType:UIAlertControllerStyle, checkButton1:String, checkButton1Type:UIAlertActionStyle, checkButton2:String?, checkButton2Type:UIAlertActionStyle?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: controllerType)
        alert.addAction(UIAlertAction(title: checkButton1, style: checkButton1Type, handler: nil))
        alert.addAction(UIAlertAction(title: checkButton2, style: checkButton2Type!, handler: nil))
        return alert
    }
    
    static func isInternetOk() -> Bool {
        let reachability = Reachability(hostName: "https://www.google.com.tw/")
        if reachability?.currentReachabilityStatus().rawValue == 0 {
            return false
        } else {
            return true
        }
    }
    
    
    static func firstDownloadImage(url:String) {
        if let imageURL = URL(string: url) {
            let fullFilePathName = NSHomeDirectory() + "/Library/CachesCache_\(imageURL.hashValue)"
            let cacheImage = UIImage(contentsOfFile: fullFilePathName)
            if cacheImage == nil {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    if error != nil {
                        return
                    } else {
                        if let checkData = data {
                            do {
                                try checkData.write(to: URL(fileURLWithPath: fullFilePathName))
                            } catch {
                                
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
   
    static func downloadImage(imageViewSet:UIImageView, URLString:String, completion:@escaping (UIImage?, UIActivityIndicatorView?) -> ()) {
        let activityIndicator = CGRect(x: (imageViewSet.bounds.width / 2) - 20  , y: (imageViewSet.bounds.height / 2) - 20 , width: 40, height: 40)
        let loading = UIActivityIndicatorView(frame: activityIndicator)
        loading.hidesWhenStopped = true
        imageViewSet.addSubview(loading)
        imageViewSet.backgroundColor = UIColor(red: 165.0/255.0, green: 165.0/255.0, blue: 165.0/255.0, alpha: 0.33)
        if let imageURL = URL(string: URLString) {
            let fullFilePathName = NSHomeDirectory() + "/Library/CachesCache_\(imageURL.hashValue)"
            let cacheImage = UIImage(contentsOfFile: fullFilePathName)
            if cacheImage != nil {
                completion(cacheImage, loading)
            } else {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    if error != nil {
                        return
                    } else {
                        if let checkData = data {
                            completion(UIImage(data: checkData), loading)
                            do {
                               try checkData.write(to: URL(fileURLWithPath: fullFilePathName))
                            } catch {
                                
                            }
                        }
                    }
                })
                DispatchQueue.main.async {
                    loading.startAnimating()
                }
                task.resume()
            }
        }
    }
    
}
