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

    // MARK: - UICollectionViewCell Extension

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

    // MARK: - UITableViewCell Extension

extension UITableViewCell {
    static var identitier: String {
        return String(describing: self)
    }
}

    // MARK: - UIImageView Extension

extension UIImageView {
    func downloadImage(urlStr: String) {
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "normalImage"))
    }
}
