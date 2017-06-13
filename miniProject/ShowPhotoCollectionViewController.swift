//
//  ShowPhotoCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/2.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class ShowPhotoCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseServer.firebase().getPhotoArrayCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowPhotoCollectionViewCell
        if FirebaseServer.firebase().getPhotoArrayCount() == 0 {
            cell.backView.isHidden = true
        } else {
            cell.backView.isHidden = false
            cell.backView.layer.cornerRadius = 4
            cell.backView.clipsToBounds = true
            cell.titleLabel.text = FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).locationName
            if FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).photoName.count != 0 {
                cell.titleImage.isHidden = false
                Library.downloadImage(imageViewSet: cell.titleImage, URLString: FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).photoName[0], completion: { (image, loading) in
                    cell.titleImage.image = image
                    loading?.stopAnimating()
                })
            } else {
                cell.titleImage.isHidden = true
            }
            cell.dateDetailLabel.text = Library.dateToShowString(date: FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).picturesDay)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FirebaseServer.firebase().saveSelectPhotoDataNum(num: indexPath.row) {
            let showPhohoTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowPhotoDetailCollectionViewController")
            navigationController?.pushViewController(showPhohoTableViewController!, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay: \(indexPath.row)")
        if FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).selectSwitch == false {
            FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).selectSwitch = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didEndDisPlaying: \(indexPath.row)")
        if FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).selectSwitch == true {
            FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).selectSwitch = false
            NotificationCenter.default.post(name: Notification.Name("changColor"), object: nil, userInfo: ["changSwitch": true])
        }
    }

}
