//
//  PhotoCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/19.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {

    @IBAction func disMissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     collectionView?.scrollToItem(at: IndexPath(item: FirebaseManager.shared.getselectPhotoDetail(), section: 0), at: .right, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.getSelectPhotoDataArrayCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        Library.downloadImage(imageViewSet: cell.photoImage, URLString: FirebaseManager.shared.getSelectPhotoDataArray(selectPhoto: indexPath.row)) { (photo, loading, view) in
            cell.photoImage.image = photo
            loading?.stopAnimating()
            view?.removeFromSuperview()
        }
        return cell
    }
    
    
}
