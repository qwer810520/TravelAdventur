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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        addSubview(qrcodeImageView)
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-80-[qrcodeImageView]-80-|",
            options: [],
            metrics: nil,
            views: ["qrcodeImageView": qrcodeImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-150-[qrcodeImageView]",
            options: [],
            metrics: nil,
            views: ["qrcodeImageView": qrcodeImageView]))
        
        NSLayoutConstraint(item: qrcodeImageView, attribute: .height, relatedBy: .equal, toItem: qrcodeImageView, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true

        qrcodeImageView.image = id.toQRCode(with: qrcodeImageView)
    }
    
    // MARK: - init Element
    
    lazy var qrcodeImageView: UIImageView = {
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
