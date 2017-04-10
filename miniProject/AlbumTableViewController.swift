//
//  AlbumTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AlbumTableViewController: UITableViewController {
    
    var album:[Album] = []
    var albumRef = FIRDatabase.database().reference().child("Album")
    
    
    @IBAction func addAlbum(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(pushViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        observeAlbum()
    }
    
    
    func observeAlbum() {
        albumRef.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let name = dict["travelName"] as? String
                let time = dict["time"] as? String
                let day = dict["day"] as? String
                let imageURL = dict["image"] as? String
                let url  = URL(string: imageURL!)
                do {
                    let data = try Data(contentsOf: url!)
                    let picture = UIImage(data: data)
                    self.album.append(Album(travelName: name!, time: time!, day: day!, titleImage: picture!, photos: [PhotoDataModel]()))
                } catch {
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumTableViewCell
        cell.albumTitle.text = album[indexPath.row].travelName
        cell.albumMessage.text = "\(album[indexPath.row].time) | \(album[indexPath.row].day) day"
        cell.albumTitleImage.image = album[indexPath.row].titleImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("開始轉場")
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        pushViewController.photoDataModel = album[indexPath.row].photos
        navigationController?.pushViewController(pushViewController, animated: true)
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            print("test")
////            let segue = segue.destination as! MapViewController
////            if let indexPath = self.tableView.indexPathForSelectedRow {
////                segue.photoDataModel = album[indexPath.row].photos
////                
////            }
//        }
//    }
}
