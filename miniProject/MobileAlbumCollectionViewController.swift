//
//  MobileAlbumCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/4/12.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD


class MobileAlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var modelImageArray = [modelPhotosData]()
    var imageArrayCount = 0
    var selectImageArray = [modelPhotosData]()
    

    @IBAction func addImageButton(_ sender: UIBarButtonItem) {
        print(selectImageArray.count)
        if selectImageArray.count != 0 {
            SVProgressHUD.show(withStatus: "上傳中...")
            FirebaseServer.firebase().savePhotoToFirebase(PhotoArray: selectImageArray, saveId: FirebaseServer.firebase().getSavePhotoId(), completion: {
                SVProgressHUD.dismiss()
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
                    NotificationCenter.default.post(name: Notification.Name("updata"), object: nil, userInfo: ["switch": "Photo"])
                    self.navigationController?.popViewController(animated: true)
                })
            })
        } else {
            present(Library.alertSet(title: "錯誤", message: "請選擇照片", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       grabPhotos()
       collectionView?.allowsMultipleSelection = true
       print(FirebaseServer.firebase().getPhotoId())
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 2, height: (UIScreen.main.bounds.width / 3) - 2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
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
                    imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { [weak self] (image, error) in
                        let photoData = modelPhotosData(image: image!, bool: false)
                      self?.modelImageArray.append(photoData)
                        self?.imageArrayCount += 1
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
            cell?.layer.borderColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 0.5).cgColor
            modelImageArray[indexPath.row].bool = true
            selectImageArray.append(modelImageArray[indexPath.row])
            print(selectImageArray.count)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("取消標記")
        let cell = collectionView.cellForItem(at: indexPath)
        if modelImageArray[indexPath.row].bool == true {
            cell?.layer.borderWidth = 4.0
            cell?.layer.borderColor = UIColor.clear.cgColor
            modelImageArray[indexPath.row].bool = false
            for i in 0..<selectImageArray.count {
                if selectImageArray[i].image == modelImageArray[indexPath.row].image {
                    selectImageArray.remove(at: i)
                    break
                }
            }
        }
    }
}
