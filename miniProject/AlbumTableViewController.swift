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
    var UserRef = Database.database().reference().child("User")
    var loadData = false

    @IBAction func addAlbum(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if UserDefaults.standard.bool(forKey: "firstLogin") == false {
            let newUser = UserRef.child((Auth.auth().currentUser?.uid)!)
            let userId = ["userId": Auth.auth().currentUser?.uid]
            newUser.setValue(userId)
            
            UserDefaults.standard.set(true, forKey: "firstLogin")
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Library.isInternetOk() == true {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
                SVProgressHUD.show(withStatus: "讀取中...")
                self.checkUser(userId: (Auth.auth().currentUser?.uid)!)
            }
        } else {
            present(Library.AlertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, button2switch: false, checkButton2: "", checkButton2Type: .default), animated: true, completion: nil)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumRef.removeAllObservers()
        UserRef.removeAllObservers()
        
    }
    
    func checkUser(userId: String) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.UserRef.observe(.value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String: AnyObject] {
                   self.album.removeAll()
                    for i in 0..<userDict.count {
                        print(Array(userDict.keys)[i])
                        if Array(userDict.keys)[i] == userId {
                            print(Array(userDict.keys)[i])
                            print(userId)
                            if let getTheAlbumId = Array(userDict.values)[i] as? [String: AnyObject] {
                                if let albumID = getTheAlbumId["participateAlbum"] as? [String:String] {
                                    self.loadData = true
                                    for x in 0..<albumID.count {
                                    self.observeAlbum(albumId: Array(albumID.keys)[x])
                                    }
                                    }
                                }
                            }
                        }
                    if self.loadData == false {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            SVProgressHUD.showSuccess(withStatus: "完成")
                            SVProgressHUD.dismiss(withDelay: 1.5)
                        }
                    }
                }
            })
        }
    }
    
    func observeAlbum(albumId:String) {
            self.album.removeAll()
            var loadAlbumModel = Album(key: String(), travelName: String(), startDate: Double(), endDate: Double(), titleImage: UIImage(), photos: [PhotoDataModel]())
            var loadPhotoModel = PhotoDataModel(albumID: String(), photoID: String(), photoName: [String](), picturesDay: String(), coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees()))
            self.albumRef.observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject] {
                    for i in 0..<dict.count {
                        if Array(dict.keys)[i] == albumId {
                        if let getDetail = Array(dict.values)[i] as? [String:AnyObject] {
                            let albumKey = Array(dict.keys)[i]
                            let name = getDetail["travelName"] as? String
                            let startDate = getDetail["startDate"] as? Double
                            let endDate = getDetail["endDate"] as? Double
                            let titleImage = getDetail["image"] as? String
                            let titleImageURL = URL(string: titleImage!)
                            do {
                                let data = try Data(contentsOf: titleImageURL!)
                                let picture = UIImage(data: data)
                                loadAlbumModel = Album(key: albumKey, travelName: name!, startDate: startDate!, endDate: endDate!, titleImage: picture!, photos: [PhotoDataModel]())
                            } catch {
                                
                            }
                            let photoDate = self.albumRef.child(albumKey).child("photos")
                            photoDate.observe(.value, with: { (snapshot) in
                                if let photodict = snapshot.value as? [String: AnyObject] {
                                    for i in 0..<photodict.count {
                                        if let getPhotoDetail = Array(photodict.values)[i] as? [String: AnyObject] {
                                            let key = Array(getPhotoDetail.keys)[i]
                                            let photoName = getPhotoDetail["photoName"] as? Array<String>
                                            let day = getPhotoDetail["day"] as? String
                                            let latitude = getPhotoDetail["latitude"] as? Double
                                            let longitude = getPhotoDetail["longitude"] as? Double
                                            loadPhotoModel = PhotoDataModel(albumID: albumKey, photoID: key, photoName: photoName!, picturesDay: day!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
                                            
                                            for i in self.album {
                                                if loadPhotoModel.albumID == i.key {
                                                    i.photos.append(loadPhotoModel)
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                            self.album.append(loadAlbumModel)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                SVProgressHUD.showSuccess(withStatus: "完成")
                                SVProgressHUD.dismiss(withDelay: 1.5)
                            }
                        }
                    }
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumTableViewCell
        print(album.count)
        if album.count == 0 {
            cell.backView.isHidden = true
            cell.albumTitle.isHidden = true
            cell.albumMessage.isHidden = true
            cell.albumTitleImage.isHidden = true
        } else {
            cell.backView.isHidden = false
            cell.albumTitle.isHidden = false
            cell.albumMessage.isHidden = false
            cell.albumTitleImage.isHidden = false
            cell.albumTitle.text = album[indexPath.row].travelName
            cell.albumMessage.text = "\(Library.dateToShowString(date: album[indexPath.row].startDate)) ~ \(Library.endDateToShowString(date: album[indexPath.row].endDate))"
            cell.albumTitleImage.image = album[indexPath.row].titleImage
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("開始轉場")
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let pushViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        pushViewController.photoDataModel = album[indexPath.row].photos
        pushViewController.day = album[indexPath.row].endDate
        pushViewController.key = album[indexPath.row].key
        print(album[indexPath.row].key)
        navigationController?.pushViewController(pushViewController, animated: true)
        
    }
}
