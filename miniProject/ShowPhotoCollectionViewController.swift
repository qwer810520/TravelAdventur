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
        layout.minimumLineSpacing = 20
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
            cell.backView.layer.cornerRadius = 4
            cell.backView.clipsToBounds = true
            cell.titleLabel.text = FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).locationName
            Library.downloadImage(imageViewSet: cell.titleImage, URLString: FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).photoName[0], completion: { (image, loading) in
                cell.titleImage.image = image
                loading?.stopAnimating()
            })
            cell.dateDetailLabel.text = Library.dateToShowString(date: FirebaseServer.firebase().getPhotoArrayData(select: indexPath.row).picturesDay)
        }
        return cell
    }

}
