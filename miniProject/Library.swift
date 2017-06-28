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
    
   
    static func downloadImage(imageViewSet:UIImageView, URLString:String, completion:@escaping (UIImage?, UIActivityIndicatorView?, UIVisualEffectView?) -> ()) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = imageViewSet.bounds
        imageViewSet.addSubview(blurEffectView)
        let loading = UIActivityIndicatorView(frame: CGRect(x: (blurEffectView.bounds.width / 2) - 20  , y: (blurEffectView.bounds.height / 2) - 20 , width: 40, height: 40))
        loading.hidesWhenStopped = true
        blurEffectView.addSubview(loading)
        if let imageURL = URL(string: URLString) {
            let fullFilePathName = NSHomeDirectory() + "/Library/CachesCache_\(imageURL.hashValue)"
            let cacheImage = UIImage(contentsOfFile: fullFilePathName)
            if cacheImage != nil {
                completion(cacheImage, loading, blurEffectView)
            } else {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    if error != nil {
                        return
                    } else {
                        if let checkData = data {
                            completion(UIImage(data: checkData), loading, blurEffectView)
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
    
    static func qrcodeImage(str:String, image:UIImageView) -> UIImage {
        var qrcodeImage:CIImage?
        let data = str.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        fileter?.setValue(data, forKey: "inputMessage")
        fileter?.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = fileter?.outputImage
        let scaleX = image.frame.size.width / (qrcodeImage?.extent.size.width)!
        let scaleY = image.frame.size.height / (qrcodeImage?.extent.size.height)!
        let transFormedImage = qrcodeImage?.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transFormedImage!)
    }
    
}
