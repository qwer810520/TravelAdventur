//
//  ShowPhohoTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/6.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import PreviewTransition
import SVProgressHUD

class ShowPhohoTableViewController: PTTableViewController {
    
   
    @IBAction func addPhotoBtu(_ sender: UIBarButtonItem) {
        let mobileAlbumCollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "MobileAlbumCollectionViewController")
        navigationController?.pushViewController(mobileAlbumCollectionViewController!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSVP(Not:)), name: Notification.Name("showSVP"), object: nil)
    }
    
    func showSVP(Not:Notification) {
        if let SVPSwitch = Not.userInfo?["switch"] as? Bool {
            if SVPSwitch == true {
                SVProgressHUD.show(withStatus: "載入中...")
            } else {
                SVProgressHUD.showSuccess(withStatus: "完成")
                SVProgressHUD.dismiss(withDelay: 1.5)
                tableViewReload()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(FirebaseServer.firebase().getSelectPhotoDataArrayCount())
        return FirebaseServer.firebase().getSelectPhotoDataArrayCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ParallaxCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showPhotoDetailViewController:PTDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowPhotoDetailViewController") as! PTDetailViewController
        pushViewController(showPhotoDetailViewController)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ParallaxCell else {
            return
        }
        print(FirebaseServer.firebase().getSelectPhotoDataArrayCount())
        if FirebaseServer.firebase().getSelectPhotoDataArrayCount() != 0 {
            let showPhoto = FirebaseServer.firebase().getSelectPhotoDataArray(selectPhoto: indexPath.row)
            
            Library.downloadImage(imageViewSet: cell.bgImage!, URLString: showPhoto, completion: { (photo, loading) in
                cell.setImage(photo!, title: "")
                loading?.stopAnimating()
            })
        }
    }
    

}
