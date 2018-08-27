//
//  TAStyle.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

enum DataToStringType {
    case all
    case day
}

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
    
    class func dateToString(date: TimeInterval, type: DataToStringType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        switch type {
        case .all:
            dateFormatter.dateFormat = "yyyy年MM月dd日"
        case .day:
            dateFormatter.dateFormat = "dd日"
        }
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
    
    class func getEndDate(start: Double, day: Int) -> TimeInterval {
        let endDouble = start + Double((24 * 60 * 60) * day)
        return TimeInterval(exactly: endDouble)!
    }
    
    class func setQRImage(str:String, image: UIImageView) -> UIImage {
        var qrcodeImage = CIImage()
        let data = str.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        guard let fileter = CIFilter(name: "CIQRCodeGenerator") else { return UIImage() }
        
        fileter.setValue(data, forKey: "inputMessage")
        fileter.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = fileter.outputImage!
        let scaleX = image.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = image.frame.size.height / qrcodeImage.extent.size.height
        
        let transFormedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transFormedImage)
    }
}
