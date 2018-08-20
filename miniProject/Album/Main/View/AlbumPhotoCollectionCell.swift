//
//  AlbumPhotoCollectionCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/20.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class AlbumPhotoCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        contentView.addSubview(imageView)
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": imageView]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": imageView]))
    }
    
    // MARK: - init Element
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
}
