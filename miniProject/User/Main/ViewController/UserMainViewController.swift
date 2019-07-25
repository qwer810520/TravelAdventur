//
//  UserMainViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class UserMainViewController: ParentViewController {
    
    lazy private var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        view.tableFooterView = UIView(frame: .zero)
        view.register(ShowProfileTableViewCell.self, forCellReuseIdentifier: ShowProfileTableViewCell.identitier)
        view.register(BlankTableViewCell.self, forCellReuseIdentifier: BlankTableViewCell.identitier)
        view.register(SearchQRcodeOrTouchIDTableViewCell.self, forCellReuseIdentifier: SearchQRcodeOrTouchIDTableViewCell.identitier)
        view.register(SignOutTableViewCell.self, forCellReuseIdentifier: SignOutTableViewCell.identitier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserProfile()
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Profile", barButtonType: .none)
         UIScreen.main.brightness = UserDefaults.standard.object(forKey: UserDefaultsKey.ScreenBrightness.rawValue) as! CGFloat
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        view.addSubview(tableView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView": tableView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(getNaviHeight())-[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView": tableView]))
    }
    
    private func getUserProfile() {
        FirebaseManager.shared.getUserProfile { [weak self] (error) in
            guard error == nil else {
                self?.showAlert(type: .check, title: (error?.localizedDescription)!)
                return
            }
        }
    }
}

    // MARK: - UITableViewDelegate

extension UserMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 160
        case 1, 2:
            return 40
        case 3:
            return 100
        case 4:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let vc = TANavigationController(rootViewController: QRCodeTearderViewController())
            present(vc, animated: true, completion: nil)
        case 4:
            if let providerData = Auth.auth().currentUser?.providerData {
                let userInfo = providerData[0]
                switch userInfo.providerID {
                case "google.com":
                    GIDSignIn.sharedInstance().signOut()
                case "facebook.com":
                    LoginManager().logOut()
                default:
                    break
                }
                do {
                    try Auth.auth().signOut()
                    view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } catch {
                    
                }
            }
        default:
            break
        }
    }
}

    // MARK: - UITableViewDataSource

extension UserMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let userProfileCell = tableView.dequeueReusableCell(withIdentifier: ShowProfileTableViewCell.identitier, for: indexPath) as! ShowProfileTableViewCell
            userProfileCell.userModel = FirebaseManager.shared.loginUserModel
            return userProfileCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchQRcodeOrTouchIDTableViewCell.identitier, for: indexPath) as! SearchQRcodeOrTouchIDTableViewCell
            cell.cellType = .QRcode
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchQRcodeOrTouchIDTableViewCell.identitier, for: indexPath) as! SearchQRcodeOrTouchIDTableViewCell
            cell.cellType = .touchID
            cell.isOn = UserDefaults.standard.bool(forKey: "touchIDSwitch")
            cell.delegate = self
            return cell
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.identitier, for: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: BlankTableViewCell.identitier, for: indexPath)
        }
    }
}

    // MARK: - searchQRcodeOrTouchIDCellDelegate

extension UserMainViewController: searchQRcodeOrTouchIDCellDelegate {
    func qrcodeSwitchValueChange(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "touchIDSwitch")
    }
}
