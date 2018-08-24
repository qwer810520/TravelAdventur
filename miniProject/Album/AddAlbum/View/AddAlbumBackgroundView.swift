//
//  AddAlbumBackgroundView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol AddAlbumDelegate: class {
    func addAlbumButtonDidPressed()
    func addAlbumCoverButtonDidPressed()
}

class AddAlbumBackgroundView: UIView {
    weak var delegate: AddAlbumDelegate?
    weak var textFieldDelegate: UITextFieldDelegate?
    
    init(delegate: AddAlbumDelegate? = nil, textFieldDelegate: UITextFieldDelegate? = nil) {
        self.delegate = delegate
        self.textFieldDelegate = textFieldDelegate
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
        backgroundImage.addSubviews([blurEffect, nameTextField, startDateTitleLabel, startTiemTextField, dayTitleLabel, selectDayTextField, addButton, addAlbumCoverPhotoButton, albumCoverPhotoImageView])
        albumCoverPhotoImageView.addSubview(addAlbumCoverPhotoButton)
        
        let views: TAStyle.JSONDictionary = ["backgroundImage": backgroundImage, "blurEffect": blurEffect, "nameTextField": nameTextField, "startTiemTextField": startTiemTextField, "startDateTitleLabel": startDateTitleLabel, "dayTitleLabel": dayTitleLabel, "selectDayTextField": selectDayTextField, "addButton": addButton, "addAlbumCoverPhotoButton": addAlbumCoverPhotoButton, "albumCoverPhotoImageView": albumCoverPhotoImageView]
        
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
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[nameTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[startDateTitleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[startTiemTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[dayTitleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[selectDayTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-40-[addButton]-40-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-60-[albumCoverPhotoImageView]-60-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[nameTextField(40)]-20-[startDateTitleLabel(30)]-5-[startTiemTextField(==nameTextField)]-20-[dayTitleLabel(==startDateTitleLabel)]-5-[selectDayTextField(==nameTextField)]-20-[albumCoverPhotoImageView]-70-[addButton(50)]-50-|",
            options: [],
            metrics: nil,
            views: views))
        
        albumCoverPhotoImageView
            .addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[addAlbumCoverPhotoButton]|",
                options: [],
                metrics: nil,
                views: views))
        
        albumCoverPhotoImageView
            .addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[addAlbumCoverPhotoButton]|",
                options: [],
                metrics: nil,
                views: views))
    }
    
    // MARK: - init Element
    
    lazy var addAlbumCoverPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCoverPhotoButtonDidPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "AddAlbum_NormalAlbumPhoto"), for: .normal)
        button.tintColor = TAStyle.orange
        return button
    }()
    
    lazy var albumCoverPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy private var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "addPlace")
        return imageView
    }()
    
    lazy private var blurEffect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.tintColor = TAStyle.orange
        view.textAlignment = .center
        view.placeholder = "請輸入行程名稱"
        view.delegate = textFieldDelegate
        return view
    }()
    
    lazy private var startDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "出發日期："
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    lazy var startTiemTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        return view
    }()
    
    lazy private var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "天數："
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    lazy var selectDayTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        return view
    }()
    
    lazy private var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont(name: TAStyle.navigationTitleFont, size: 20.0)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = TAStyle.orange
        button.addTarget(self, action: #selector(addAlbumButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action Method
    
    @objc private func addAlbumButtonDidPressed() {
        guard let delegate = self.delegate else { return }
        delegate.addAlbumButtonDidPressed()
    }
    
    @objc private func addCoverPhotoButtonDidPressed() {
        guard let delegate = self.delegate else { return }
        delegate.addAlbumCoverButtonDidPressed()
    }
}
