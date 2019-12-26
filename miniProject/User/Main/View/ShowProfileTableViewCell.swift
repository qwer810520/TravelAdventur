//
//  ShowProfileTableViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import SDWebImage

class ShowProfileTableViewCell: UITableViewCell {
    
    var userModel: LoginUserModel? {
        didSet {
            guard let user = userModel else { return }
            userNameLabel.text = user.name
            userImageView.sd_setImage(with: URL(string: user.photoURL), placeholderImage: UIImage(named: "UserNormalImage"))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        self.selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubviews([userImageView, userNameLabel])
        
        NSLayoutConstraint(item: userImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: userImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[userNameLabel]|",
            options: [],
            metrics: nil,
            views: ["userImageView": userImageView, "userNameLabel": userNameLabel]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[userImageView(100)]-20-[userNameLabel]-10-|",
            options: [],
            metrics: nil,
            views: ["userImageView": userImageView, "userNameLabel": userNameLabel]))
    }
    
    // MARK: - init Element
    
    lazy private var userImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy private var userNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.textAlignment = .center
        return view
    }()
}
