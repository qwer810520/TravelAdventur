//
//  SignOutTableViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class SignOutTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(signOutTitleLabel)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[signOutTitleLabel]|",
            options: [],
            metrics: nil,
            views: ["signOutTitleLabel": signOutTitleLabel]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[signOutTitleLabel]|",
            options: [],
            metrics: nil,
            views: ["signOutTitleLabel": signOutTitleLabel]))
    }
    
    lazy private var signOutTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "登出"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
}
