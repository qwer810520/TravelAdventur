//
//  AddAlbumQRCodeView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class AddAlbumQRCodeView: UIView {
    var id: String
    
    init(id: String) {
        self.id = id
        super.init(frame: .zero)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        self.addSubview(QRImageView)
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-80-[QRImageView]-80-|",
            options: [],
            metrics: nil,
            views: ["QRImageView": QRImageView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-150-[QRImageView]",
            options: [],
            metrics: nil,
            views: ["QRImageView": QRImageView]))
        
        NSLayoutConstraint(item: QRImageView, attribute: .height, relatedBy: .equal, toItem: QRImageView, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    // MARK: - init Element
    
    lazy var QRImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
