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

class ParentViewController: UIViewController {
    
    private let reachability = Reachability()
    private(set) var isLoading = false
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.7058823529, alpha: 1)
        
    }
    
    func setNavigation(title: String) {
        
    }
    
    func showAlert(title: String, message: String? = nil, checkAction: ((UIAlertAction) -> ())? = nil) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "確定", style: .default, handler: checkAction))
        alertVC.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Reachability Library
    
    func isNetworkConnected() -> Bool {
        guard let netWorkStatus = reachability?.connection, netWorkStatus != .none  else {
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
        SVProgressHUD.dismiss(withDelay: 1)
        isLoading = false
    }
}