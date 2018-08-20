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
        backgroundImage.addSubviews([nameTitleLabel, nameTextField, startTiemTextField, timeSpaceLabel, endTimeTextField])
        
        let views: TAStyle.JSONDictionary = ["backgroundImage": backgroundImage,"nameTitleLabel": nameTitleLabel, "nameTextField": nameTextField, "startTiemTextField": startTiemTextField, "timeSpaceLabel": timeSpaceLabel, "endTimeTextField": endTimeTextField]
        
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
            withVisualFormat: "H:|-15-[nameTitleLabel(40)]-5-[nameTextField]-15-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[startTiemTextField(==endTimeTextField)]-2-[timeSpaceLabel(5)]-2-[endTimeTextField(==startTiemTextField)]-15-|",
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
    
    lazy private var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "相簿名稱："
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        return view
    }()
    
    lazy var startTiemTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        return view
    }()
    
    lazy var timeSpaceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " ~ "
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    lazy var endTimeTextField: UITextField = {
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
