//
//  MobileAlbumCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/12.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Photos

class MobileAlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var mobileImageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
      grabPhotos()
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
                      self.mobileImageArray.append(image!)
                    })
                }
            } else {
                print("你拿到相片了")
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mobileImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MobilePhotosCollectionViewCell
        
        cell.inputImage.image = mobileImageArray[indexPath.row]
        
        return cell
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
