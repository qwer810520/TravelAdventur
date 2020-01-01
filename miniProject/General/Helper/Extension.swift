//
//  Extension.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/16.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import SDWebImage

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

    // MARK: - UIView Extension

extension TimeInterval {
    func calculationEndTimeInterval(with day: Int) -> TimeInterval {
        return self + Double((24 * 60 * 60) * day)
    }
}

    // MARK: - String Extension

extension String {
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
