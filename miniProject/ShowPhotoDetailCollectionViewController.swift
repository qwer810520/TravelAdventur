//
//  ShowPhotoCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/13.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import TRMosaicLayout
import SVProgressHUD

class ShowPhotoDetailCollectionViewController: UICollectionViewController, TRMosaicLayoutDelegate {
    
    @IBAction func addPhotoButton(_ sender: UIBarButtonItem) {
        let mobileAlbumCollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "MobileAlbumCollectionViewController")
        navigationController?.pushViewController(mobileAlbumCollectionViewController!, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showSVP(Not:)), name: Notification.Name("showSVP"), object: nil)
    }
    
    func showSVP(Not:Notification) {
        if let SVPSwitch = Not.userInfo?["switch"] as? Bool {
            if SVPSwitch == true {
                SVProgressHUD.show(withStatus: "載入中...")
            } else {
                SVProgressHUD.showSuccess(withStatus: "完成")
                SVProgressHUD.dismiss(withDelay: 1.5)
                collectionView?.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseServer.firebase().getSelectPhotoDataArrayCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        Library.downloadImage(imageViewSet: cell.inputImage, URLString: FirebaseServer.firebase().getSelectPhotoDataArray(selectPhoto: indexPath.row)) { (photo, loading) in
            cell.inputImage.image = photo
            loading?.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }

    
}
