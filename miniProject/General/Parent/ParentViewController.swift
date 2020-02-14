//
//  ParentViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
//import SVProgressHUD
import Photos

enum NaviBarButtonType {
  case none
  case _add
  case dismiss_
  case back_addPlace
  case back_addPhoto
  case back_
}

enum AlertType {
  case check
  case cancel_check
}

class ParentViewController: UIViewController {

  var navigationHeight: CGFloat {
    return getNavigationAndStatusBarHeight()
  }

  var tabbarHeight: CGFloat {
    return tabBarController?.tabBar.frame.height ?? 0
  }

  private let loadingBackgroudView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    view.backgroundColor = .clear
    return view
  }()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    navigationItem.hidesBackButton = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUserInterface()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

  // MARK: - private Method

  private func setUserInterface() {
    view.backgroundColor = .defaultBackgroundColor
  }

  private func getNavigationAndStatusBarHeight() -> CGFloat {
    var statbarHeight: CGFloat = 0
    let naviHeight = navigationController?.navigationBar.frame.height ?? 0
    if #available(iOS 13, *) {
      statbarHeight = UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
      statbarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statbarHeight + naviHeight
  }

  func setNavigation(title: String?, barButtonType: NaviBarButtonType = .none) {
    navigationItem.title = title
    navigationItem.rightBarButtonItem = nil
    navigationItem.leftBarButtonItem = nil
    let backItem = UIBarButtonItem(image: "BarButtonItem_backIcon", target: self, action: #selector(popButtonDidPressed))
    switch barButtonType {
      case ._add:
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidPressed))
      case .dismiss_:
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "navi_dismissItem_Icon", target: self, action: #selector(dismissButtonDidPressed))
      case .back_addPlace:
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: "navi_addLocationItem_Icon", target: self, action: #selector(addButtonDidPressed))
      case .back_addPhoto:
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: "navi_addPhotoItem_Icon", target: self, action: #selector(addButtonDidPressed))
      case .back_:
        navigationItem.leftBarButtonItem = backItem
      case .none:
        break
    }
  }

  func showAlert(title: String, message: String? = nil, rightTitle: String = "確定", rightAction: ((UIAlertAction) -> Void)? = nil, leftTitle: String? = nil, leftAction: ((UIAlertAction) -> Void)? = nil) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let leftTitle = leftTitle {
      alertVC.addAction(UIAlertAction(title: leftTitle, style: .default, handler: leftAction))
    }
    alertVC.addAction(UIAlertAction(title: rightTitle, style: .default, handler: rightAction))
    present(alertVC, animated: true, completion: nil)
  }

  func selectTabbarItem(type: TATabbarItem) {
    guard let tabbarController = tabBarController as? TATabbarController else { return }
    tabbarController.selectItem(item: type)
  }

  // MARK: - Action Method

  @objc private func dismissButtonDidPressed() {
    dismiss(animated: true, completion: nil)
  }

  @objc func addButtonDidPressed() {

  }

  @objc private func popButtonDidPressed() {
    navigationController?.popViewController(animated: true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    if #available(iOS 13, *) {
      viewControllerToPresent.modalPresentationStyle = .fullScreen
    }
    super.present(viewControllerToPresent, animated: flag, completion: completion)
  }

  // MARK: - SVProgressHUD Library

  func startLoading(status: String? = nil) {
    //        guard !isLoading else { return }
    //        UIApplication.shared.keyWindow?.addSubview(loadingBackgroudView)
    //        SVProgressHUD.show(withStatus: status)
    //        isLoading = true
  }

  func stopLoading() {
    //        guard isLoading else { return }
    //        loadingBackgroudView.removeFromSuperview()
    //        SVProgressHUD.showSuccess(withStatus: "完成")
    //        SVProgressHUD.dismiss(withDelay: 1)
    //        isLoading = false
  }

}
