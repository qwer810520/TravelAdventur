//
//  TAToolBar.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/23.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class TAToolBar: UIToolbar {
    var checkAction: (() -> ())?
    var cancelAction: (() -> ())?
    
    init(cancelAction: (() -> ())? = nil, checkAction: (() -> ())? = nil) {
        self.cancelAction = cancelAction
        self.checkAction = checkAction
        super.init(frame: .zero)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        self.barStyle = .default
        self.isTranslucent = true
        self.sizeToFit()
        self.items = [cancelButtonItem, spaceButtonItem, checkButtonItem]
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - init Element
    
    private var checkButtonItem: UIBarButtonItem = {
        return TABarButtonItem.setTitleBarButtonItem(title: "確定", target: self, action: #selector(checkButtonItemDidPressed))
    }()
    
    private var cancelButtonItem: UIBarButtonItem = {
        return TABarButtonItem.setTitleBarButtonItem(title: "取消", target: self, action: #selector(cancelButtonItemDidPressed))
    }()
    
    private var spaceButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    }()
    
    // MARK: - Action Method
    
    @objc private func checkButtonItemDidPressed() {
        guard let checkAction = checkAction else { return }
        checkAction()
    }
    
    @objc private func cancelButtonItemDidPressed() {
        guard let cancelAction = checkAction else { return }
        cancelAction()
    }
}
