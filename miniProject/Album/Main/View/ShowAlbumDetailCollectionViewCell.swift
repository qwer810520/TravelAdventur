//
//  ShowAlbumDetailCollectionViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/24.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class ShowAlbumDetailCollectionViewCell: UICollectionViewCell {
    
    var albumModel: AlbumModel? {
        didSet {
            guard let albumModel = albumModel else { return }
            imageView.downloadImage(urlStr: albumModel.coverPhotoURL)
            titleLabel.text = albumModel.title
            timeLabel.text = albumModel.startTime.dateToString(type: .all) + " ~ " + albumModel.startTime.calculationEndTimeInterval(with: albumModel.day).dateToString(type: .day)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func setUserInterface() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        contentView.addSubviews([imageView, titleLabel, timeLabel])
        
        let views: [String: Any] = ["imageView": imageView, "titleLabel": titleLabel, "timeLabel": timeLabel]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[imageView]|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[titleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[timeLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[imageView]-10-[titleLabel(18)]-15-[timeLabel(20)]-10-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init Element
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        if #available(iOS 11, *) {
            view.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
}
