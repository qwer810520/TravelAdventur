//
//  ParentViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/7/15.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos

enum NaviBarButtonType {
    case none
    case _Add
    case Dismiss_
    case Back_Add
    case Back_
}

enum AlertType {
    case check
    case cancel_check
}

class ParentViewController: UIViewController {
    
    private(set) var isLoading = false
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.7058823529, alpha: 1)
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
        case .Back_:
            navigationItem.leftBarButtonItem = TABarButtonItem.setImageBarButtonItem(imageName: "BarButtonItem_backIcon", target: self, action: #selector(popButtonDidPressed))
        case .none:
            break
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
    
    func getNaviHeight() -> CGFloat {
        return (UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!)
    }
    
    func checkPermission(handler: @escaping () -> ()) {     //相簿認證
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
        
    }
    
    // MARK: - Reachability Library
    
    func isNetworkConnected() -> Bool {
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
