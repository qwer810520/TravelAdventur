//
//  Extension.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/16.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import SDWebImage

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIImageView {
    func downloadImage(urlStr: String) {
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "normalImage"))
    }
}
