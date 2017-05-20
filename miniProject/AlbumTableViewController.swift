//
//  AlbumTableViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/26.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD

class AlbumTableViewController: UITableViewController {
    
    var album:[Album] = []
    var albumRef = Database.database().reference().child("Album")

    @IBAction func addAlbum(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(pushViewController, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        observeAlbum()
    }
    
    func observeAlbum() {
        SVProgressHUD.show(withStatus: "讀取中...")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            self.album.removeAll()
            self.albumRef.observe(.childAdded) { (snapshot: DataSnapshot) in
                var test = Album(key: "", travelName: "", time: "", day: "", titleImage: UIImage(), photos: [PhotoDataModel]())
                if let dict = snapshot.value as? [String: AnyObject] {
                    let key = snapshot.key
                    let name = dict["travelName"] as? String
                    let time = dict["time"] as? String
                    let day = dict["day"] as? String
                    let imageURL = dict["image"] as? String
                    let url  = URL(string: imageURL!)
                    let photosData = self.albumRef.child(key).child("photos")
                    do {
                        let data = try Data(contentsOf: url!)
                        let picture = UIImage(data: data)
                        test = Album(key: key, travelName: name!, time: time!, day: day!, titleImage: picture!, photos: [PhotoDataModel]())
                    } catch {
                        
                    }
                    photosData.observe(.childAdded, with: { (snapshot:DataSnapshot) in
                        print("近來做事情摟")
                        var photoDetail = PhotoDataModel(photoID: "", photoName: ["", ""], picturesDay: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
                        if let photoDict = snapshot.value as? [String: AnyObject] {
                            let key = snapshot.key
                            let photosName = photoDict["photosName"] as? Array<String>
                            let day = photoDict["day"] as? String
                            let latitude = photoDict["latitude"] as? Double
                            let longitude = photoDict["longitude"] as? Double
                            
                            photoDetail = PhotoDataModel(photoID: key, photoName: photosName!, picturesDay: day!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
                            test.photos.append(photoDetail)
                        }
                    })
                    
                }
                self.album.append(test)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: "完成")
                    SVProgressHUD.dismiss(withDelay: 1.5)
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
        pushViewController.day = album[indexPath.row].day
        pushViewController.key = album[indexPath.row].key
        print(album[indexPath.row].key)
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }
}
