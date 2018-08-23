//
//  AddAlbumBackgroundView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol AddAlbumDelegate: class {
    func addButtonDidPressed()
}

class AddAlbumBackgroundView: UIView {
    weak var delegate: AddAlbumDelegate?
    
    init() {
        super.init(frame: .zero)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func setUserInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        self.addSubview(backgroundImage)
        backgroundImage.addSubview(blurEffect)
        blurEffect.addSubviews([nameTextField, startDateTitleLabel, startTiemTextField, dayTitleLabel, selectDayTextField])
        
        let views: TAStyle.JSONDictionary = ["backgroundImage": backgroundImage, "blurEffect": blurEffect, "nameTextField": nameTextField, "startTiemTextField": startTiemTextField, "startDateTitleLabel": startDateTitleLabel, "dayTitleLabel": dayTitleLabel, "selectDayTextField": selectDayTextField, "addButton": addButton]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[backgroundImage]|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[backgroundImage]|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[blurEffect]|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[blurEffect]|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[nameTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[startDateTitleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[startTiemTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[dayTitleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[selectDayTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-100-[addButton]-100-|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[nameTextField(40)]-20-[startDateTitleLabel(30)]-5-[startTiemTextField(==nameTextField)]-20-[dayTitleLabel(==startDateTitleLabel)]-5-[selectDayTextField(==nameTextField)]|",
            options: [],
            metrics: nil,
            views: views))
        
        blurEffect.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V[addButton(40)]-50-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init Element
    
    lazy private var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var blurEffect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.placeholder = "請輸入行程名稱"
        return view
    }()
    
    lazy private var startDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "出發日期："
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var startTiemTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        return view
    }()
    
    lazy private var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "天數："
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var selectDayTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("新增相簿", for: .normal)
        button.tintColor = .white
        button.backgroundColor = TAStyle.orange
        button.addTarget(self, action: #selector(addAlbumButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action Method
    
    @objc private func addAlbumButtonDidPressed() {
        addButton.isEnabled = false
    }
}
