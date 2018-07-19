//
//  UserMenuTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/19.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class UserMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    @IBAction func touchIDSet(_ sender: UISwitch) {
        if sender.isOn == true {
            UserDefaults.standard.set(true, forKey: "touchIDSwitch")
        } else {
            UserDefaults.standard.set(false, forKey: "touchIDSwitch")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        userPhoto.clipsToBounds = true
        
        Library.downloadImage(imageViewSet: userPhoto, URLString: FirebaseManager.shared.getUserData().userPhoto!) { (photo, loading, view) in
            self.userPhoto.image = photo
            loading?.stopAnimating()
            view?.removeFromSuperview()
        }
        
        userName.text = FirebaseManager.shared.getUserData().userName
        
        if UserDefaults.standard.bool(forKey: "touchIDSwitch") == true {
            touchIDSwitch.isOn = true
        } else {
            touchIDSwitch.isOn = false
        }
        let view = UIView()
        view.backgroundColor = .black
        tableView.tableFooterView = view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            if let providerData = Auth.auth().currentUser?.providerData {
                let userInfo = providerData[0]
                switch userInfo.providerID {
                case "google.com":
                    GIDSignIn.sharedInstance().signOut()
                    do {
                        try Auth.auth().signOut()
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    } catch {
                        
                    }
                case "facebook.com":
                    FBSDKLoginManager().logOut()
                    do {
                        try Auth.auth().signOut()
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    } catch {
                        
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    
}
