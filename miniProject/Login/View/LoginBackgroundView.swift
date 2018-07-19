//
//  LoginBackgroundView.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/16.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

protocol LoginBackgroundViewDelegate: class {
    func fbButtonDidPressed()
    func googleButtonDidPressed()
}

class LoginBackgroundView: UIView {
    weak var delegate: LoginBackgroundViewDelegate?
    
    init(delegate: LoginBackgroundViewDelegate? = nil) {
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
        updateConstraints()
    }
    
    private func setAutoLayout() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubviews([orImageView, buttonBackgroundView])
        buttonBackgroundView.addSubviews([fbLoginButton, googleLoginButton])
        let views: [String: Any] = ["backgroundImageView": backgroundImageView, "orImageView": orImageView,"buttonBackgroundView": buttonBackgroundView,  "fbLoginButton": fbLoginButton, "googleLoginButton": googleLoginButton]
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[backgroundImageView]|",
            options: [],
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[backgroundImageView]|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImageView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[orImageView]-25-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImageView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-70-[buttonBackgroundView]-70-|",
            options: [],
            metrics: nil,
            views: views))
        
        backgroundImageView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[orImageView(15)]-20-[buttonBackgroundView(60)]-60-|",
            options: [],
            metrics: nil,
            views: views))
        
        buttonBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[fbLoginButton]|",
            options: [],
            metrics: nil,
            views: views))
        
        buttonBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[googleLoginButton]|",
            options: [],
            metrics: nil,
            views: views))
        
        buttonBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[googleLoginButton(60)]|",
            options: [],
            metrics: nil,
            views: views))
        
        buttonBackgroundView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[fbLoginButton(==googleLoginButton)]",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init
    
    lazy private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "login_backgroundPhoto")
        return imageView
    }()
    
    lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy private var orImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "login_orLineImage")
        return imageView
    }()
    
    lazy private var fbLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "login_FBImage"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(fbLoginButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    lazy private var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "login_Google+Image"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(googleLoginButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - action Method
    
    @objc fileprivate func fbLoginButtonDidPressed() {
//        fbLoginButton.isEnabled = false
        guard let delegate = delegate else { return }
        delegate.fbButtonDidPressed()
    }
    
    @objc fileprivate func googleLoginButtonDidPressed() {
//        googleLoginButton.isEnabled = false
        guard let delegate = delegate else { return }
        delegate.googleButtonDidPressed()
    }
}
