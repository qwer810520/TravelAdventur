//
//  ParentViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import Reachability
import SVProgressHUD
import Photos

enum NaviBarButtonType {
    case _Add
    case Dismiss_
    case Back_Add
}

enum AlertType {
    case check
    case cancel_check
}

class ParentViewController: UIViewController {
    
    private let reachability = Reachability()
    private(set) var isLoading = false
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let loadingBackgroudView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .clear
        return view
    }()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.7058823529, alpha: 1)
        navigationItem.hidesBackButton = true
    }
    
    func setNavigation(title: String?, barButtonType: NaviBarButtonType) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        
        switch barButtonType {
        case ._Add:
            navigationItem.rightBarButtonItem = TABarButtonItem.setAddBarButton(target: self, action: #selector(addButtonDidPressed))
        case .Dismiss_:
            navigationItem.leftBarButtonItem = TABarButtonItem.setDismissButton(target: self, action: #selector(dismissButtonDidPressed))
        case .Back_Add:
            navigationItem.leftBarButtonItem = TABarButtonItem.setImageBarButtonItem(imageName: "BarButtonItem_backIcon", target: self, action: #selector(popButtonDidPressed))
            navigationItem.rightBarButtonItem = TABarButtonItem.setAddBarButton(target: self, action: #selector(addButtonDidPressed))
        }
    }
    
    func showAlert(type: AlertType, title: String, message: String? = nil, checkAction: ((UIAlertAction) -> ())? = nil) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        if type == .cancel_check {
            alertVC.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        }
        alertVC.addAction(UIAlertAction(title: "確定", style: .default, handler: checkAction))
        present(alertVC, animated: true, completion: nil)
    }
    
    func selectTabbarItem(type: TATabbarItem) {
        guard let tabbarController = tabBarController as? TATabbarController else { return }
        tabbarController.selectItem(item: type)
    }
    
    //相簿認證
    func checkPermission(handler: @escaping () -> ()) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            handler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                print("status is \(newStatus)")
                guard newStatus == PHAuthorizationStatus.authorized else { return }
                handler()
            }
        case .denied:
            print("User has denied the permission.")
        case .restricted:
             print("User do not have access to photo album.")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    // MARK: - Reachability Library
    
    func isNetworkConnected() -> Bool {
        guard let netWorkStatus = reachability?.connection, netWorkStatus != .none  else {
            showAlert(type: .check, title: "網路無法連線，請確認網路是否開啟", message: nil, checkAction: nil)
            return false
        }
        return true
    }
    
    // MARK: - SVProgressHUD Library
    
    func startLoading(status: String? = nil) {
        guard !isLoading else { return }
        UIApplication.shared.keyWindow?.addSubview(loadingBackgroudView)
        SVProgressHUD.show(withStatus: status)
        isLoading = true
    }
    
    func stopLoading() {
        guard isLoading else { return }
        loadingBackgroudView.removeFromSuperview()
        SVProgressHUD.showSuccess(withStatus: "完成")
        SVProgressHUD.dismiss(withDelay: 1)
        isLoading = false
    }
}
