//
//  Extension.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/16.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import SDWebImage

enum DataToStringType {
    case all, day
}

extension DataToStringType {
    var format: String {
        return self == .all ? "yyyy年MM月dd日" : "dd日"
    }
}

    // MARK: - UIView Extension

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

    // MARK: - UIView Extension

extension UIFont {
    class var navigationTitleFont: UIFont {
        guard let font = self.init(name: "Avenir-Light", size: 24) else {
            fatalError("navigationTitleFont init Fail")
        }
        return font
    }
}

    // MARK: - UIColor Extension

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 100.0)
    }

    class var pinkPeacock: UIColor {
        return .init(r: 206, g: 91, b: 120, a: 100)
    }

    class var defaultBackgroundColor: UIColor {
        return .init(r: 236, g: 232, b: 225, a: 100)
    }
}

    // MARK: - UIViewController Extension

extension UIViewController {
    func createImage(from size: CGSize, with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
}

    // MARK: - TimeInterval Extension

extension TimeInterval {
    func calculationEndTimeInterval(with day: Int) -> TimeInterval {
        return self + Double((24 * 60 * 60) * day)
    }

    func dateToString(type: DataToStringType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = type.format
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}

    // MARK: - String Extension

extension String {
    var toImage: UIImage? {
        return UIImage(named: self)?.withRenderingMode(.alwaysOriginal)
    }

    func toQRCode(with imageView: UIImageView) -> UIImage {
        var qrcodeImage = CIImage()
        let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        guard let fileter = CIFilter(name: "CIQRCodeGenerator") else { return UIImage() }

        fileter.setValue(data, forKey: "inputMessage")
        fileter.setValue("Q", forKey: "inputCorrectionLevel")
        guard let outPutImage = fileter.outputImage else { return UIImage() }
        qrcodeImage = outPutImage
        let scaleX = imageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imageView.frame.size.height / qrcodeImage.extent.size.height

        let transFormedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transFormedImage)
    }
}

    // MARK: - UIBarButtonItem Extension

extension UIBarButtonItem {
    convenience init(image name: String, target: Any, action: Selector) {
        self.init(image: name.toImage, style: .plain, target: target, action: action)
    }

    convenience init(title: String, target: Any, action: Selector) {
        self.init(title: title, style: .plain, target: target, action: action)
    }
}

    // MARK: - UICollectionViewCell Extension

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

    // MARK: - UICollectionView extension

extension UICollectionView {
    func register(with cells: [UICollectionViewCell.Type]) {
        cells.forEach { register($0.self, forCellWithReuseIdentifier: $0.identifier) }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        guard let customCell = dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as? T else {
            fatalError("\(cell.identifier) init Fail")
        }
        return customCell
    }
}

    // MARK: - UITableViewCell Extension

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

    // MARK: - UITableView extension

extension UITableView {
    func register(with cells: [UITableViewCell.Type]) {
        cells.forEach { register($0.self, forCellReuseIdentifier: $0.identifier) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with cell: T.Type, for indexPath: IndexPath ) -> T {
        guard let customCell = dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? T else {
            fatalError("\(cell.identifier) init Fail")
        }
        return customCell
    }
}

    // MARK: - UIImageView Extension

extension UIImageView {
    func downloadImage(urlStr: String) {
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "normalImage"))
    }
}
