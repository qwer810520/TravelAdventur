//
//  UserMenuTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/19.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

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
        
        Library.downloadImage(imageViewSet: userPhoto, URLString: FirebaseServer.firebase().getUserData().userPhoto!) { (photo, loading, view) in
            self.userPhoto.image = photo
            loading?.stopAnimating()
            view?.removeFromSuperview()
        }
        
        userName.text = FirebaseServer.firebase().getUserData().userName
        
        if UserDefaults.standard.bool(forKey: "touchIDSwitch") == true {
            touchIDSwitch.isOn = true
        } else {
            touchIDSwitch.isOn = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
