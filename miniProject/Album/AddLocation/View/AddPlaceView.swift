//
//  AddLocationView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/25.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol AddPlaceDelegate: class {
    func addPlaceButtonDidPressed()
}

class AddPlaceView: UIView {
    weak var delegate: AddPlaceDelegate?
    
    init(delegate: AddPlaceDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func setUserInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        setAutoLayout()
        
    }
    
    private func setAutoLayout() {
        self.addSubviews([blurEffect, selectLocationTextField, photoDayTitleLabel, selectPhotoDayTextField, addButton])
        
        let views: [String: Any] = ["blurEffect": blurEffect, "selectLocationTextField": selectLocationTextField, "photoDayTitleLabel": photoDayTitleLabel, "selectPhotoDayTextField": selectPhotoDayTextField, "addButton": addButton]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[blurEffect]|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[blurEffect]|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[selectLocationTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[photoDayTitleLabel]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[selectPhotoDayTextField]-20-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-40-[addButton]-40-|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[selectLocationTextField(40)]-20-[photoDayTitleLabel(30)]-5-[selectPhotoDayTextField(==selectLocationTextField)]",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[addButton(50)]-50-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init Element
    
    lazy private var blurEffect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var selectLocationTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "請輸入拍照地點"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        return view
    }()
    
    lazy private var photoDayTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "拍照日期："
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .white
        return label
    }()
    
    lazy var selectPhotoDayTextField: UITextField = {
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
        button.addTarget(self, action: #selector(addPlaceButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action method
    
    @objc private func addPlaceButtonDidPressed() {
        guard let delegate = delegate else { return }
        delegate.addPlaceButtonDidPressed()
    }
}
