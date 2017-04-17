//
//  MobileAlbumCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/12.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import FirebaseDatabase

class MobileAlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var modelImageArray = [modelPhotosData]()
    var imageArrayCount = 0
    var selectImageArray = [modelPhotosData]()
    

    @IBAction func addImageButton(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("selectPhotos"), object: nil, userInfo: ["photos": selectImageArray])
    }
    
    func updataToFirebase() {
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      grabPhotos()
    collectionView?.allowsMultipleSelection = true
        
    }
    
    
    func grabPhotos() {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
        if fetchResult.count > 0 {
            
                for i in 0..<fetchResult.count {
                    imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        let photoData = modelPhotosData(image: image!, bool: false)
                      self.modelImageArray.append(photoData)
                        self.imageArrayCount += 1
                    })
                }
            } else {
                print("你拿到相片了")
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MobilePhotosCollectionViewCell
        
        cell.inputImage.image = modelImageArray[indexPath.row].image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if  modelImageArray[indexPath.row].bool == false {
            print("標記成橘色")
            cell?.layer.borderWidth = 4.0
            cell?.layer.borderColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 1.0).cgColor
            modelImageArray[indexPath.row].bool = true
            selectImageArray.append(modelImageArray[indexPath.row])
            print(selectImageArray.count)
        } else {
            print("取消標記")
            cell?.layer.borderWidth = 4.0
            cell?.layer.borderColor = UIColor.clear.cgColor
            modelImageArray[indexPath.row].bool = false
            for i in 0...selectImageArray.count - 1 {
                if selectImageArray[i].image == modelImageArray[indexPath.row].image  {
                    selectImageArray.remove(at: i)
                    break
                }
            }
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1 
  
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    

   

}
