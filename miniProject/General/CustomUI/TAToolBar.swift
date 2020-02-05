//
//  TAToolBar.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/23.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

class TAToolBar: UIToolbar {
  var checkAction: (() -> Void)?
  var cancelAction: (() -> Void)?
  
  init(cancelAction: (() -> Void)? = nil, checkAction: (() -> Void)? = nil) {
    self.cancelAction = cancelAction
    self.checkAction = checkAction
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
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
    let item = UIBarButtonItem(title: "確定", target: self, action: #selector(checkButtonItemDidPressed))
    item.tintColor = .pinkPeacock
    return item
  }()
  
  private var cancelButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(title: "取消", target: self, action: #selector(cancelButtonItemDidPressed))
    item.tintColor = .pinkPeacock
    return item
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
    guard let cancelAction = cancelAction else { return }
    cancelAction()
  }
}
