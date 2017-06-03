//
//  AlbumTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import SVProgressHUD

class AlbumTableViewController: UITableViewController {

    @IBAction func addAlbum(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Library.isInternetOk() == true {
                SVProgressHUD.show(withStatus: "讀取中...")
            FirebaseServer.firebase().loadAllData(getType: .value, completion: { 
                SVProgressHUD.showSuccess(withStatus: "完成")
                SVProgressHUD.dismiss(withDelay: 1.5)
                self.tableView.reloadData()
            })
        } else {
            present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return FirebaseServer.firebase().dataArrayCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumTableViewCell
        print(FirebaseServer.firebase().dataArrayCount())
        if FirebaseServer.firebase().dataArrayCount() == 0 {
            cell.backView.isHidden = true
            cell.albumTitle.isHidden = true
            cell.albumMessage.isHidden = true
            cell.albumTitleImage.isHidden = true
        } else {
            cell.backView.isHidden = false
            cell.albumTitle.isHidden = false
            cell.albumMessage.isHidden = false
            cell.albumTitleImage.isHidden = false
            cell.albumTitle.text = FirebaseServer.firebase().dataArray(select: indexPath.row).travelName
            cell.albumMessage.text = "\(Library.dateToShowString(date: FirebaseServer.firebase().dataArray(select: indexPath.row).startDate)) ~ \(Library.endDateToShowString(date: FirebaseServer.firebase().dataArray(select: indexPath.row).endDate))"
            Library.downloadImage(imageViewSet: cell.albumTitleImage, URLString: FirebaseServer.firebase().dataArray(select: indexPath.row).titleImage, completion: { (image, loading) in
                cell.albumTitleImage.image = image
                loading?.stopAnimating()
            })
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("開始轉場")
        FirebaseServer.firebase().saveSelectNumber(num: indexPath.row)
        let googleMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "GoogleMapViewController")
        navigationController?.pushViewController(googleMapViewController!, animated: true)
        
    }
}
