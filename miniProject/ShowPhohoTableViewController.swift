//
//  ShowPhohoTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/6.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import PreviewTransition

class ShowPhohoTableViewController: PTTableViewController {
    
   
    @IBAction func addPhotoBtu(_ sender: UIBarButtonItem) {
        let mobileAlbumCollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "MobileAlbumCollectionViewController")
        navigationController?.pushViewController(mobileAlbumCollectionViewController!, animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseServer.firebase().getSelectPhotoDataArrayCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowPhotoTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ParallaxCell else {
            return
        }
        
        if FirebaseServer.firebase().getSelectPhotoDataArrayCount() != 0 {
            let showPhoto = FirebaseServer.firebase().getSelectPhotoDataArray(selectPhoto: indexPath.row)
            
            if let photo = UIImage(named: showPhoto) {
                cell.setImage(photo, title: "")
            }
        }
    }
    

}
