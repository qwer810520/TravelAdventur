//
//  ShowPhotoViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/29.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit


class ShowPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var addCollectionView: UICollectionView!
    
    
    
    @IBAction func addPhotos(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let mobileAlbumCollectionViewController = storyboard.instantiateViewController(withIdentifier: "MobileAlbumCollectionViewController") as? MobileAlbumCollectionViewController
        mobileAlbumCollectionViewController?.key = key
        mobileAlbumCollectionViewController?.photoKey = photosKey
        navigationController?.pushViewController(mobileAlbumCollectionViewController!, animated: true)
    }
 
    
    var photoArray:Array<String> = []
    var imageArray:Array<UIImage> = []
    var key:String?
    var photosKey:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView.delegate = self
        addCollectionView.dataSource = self
        for x in photoArray {
            if x != "" {
            let image = UIImage(named: x)
            imageArray.append(image!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         NotificationCenter.default.addObserver(self, selector: #selector(ShowPhotoViewController.addPhoto(Not:)), name: Notification.Name("selectPhotos"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("photosArray"), object: nil, userInfo: ["photosName": imageArray])
    }

    
    func addPhoto(Not:Notification) {
        if let photos = Not.userInfo?["photos"] as? [modelPhotosData] {
            for i in photos {
                imageArray.append(i.image)
            }
            print(imageArray.count)
        }
       addCollectionView.reloadData()
    }
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        if imageArray.count != 0 {
        cell.inputImage.image = imageArray[indexPath.row]
            
        }
        
        return cell
    }
    
}
