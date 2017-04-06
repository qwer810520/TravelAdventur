//
//  ShowPhotoViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/3/29.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class ShowPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var addCollectionView: UICollectionView!
    
 
    
    var photoArray:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView.delegate = self
        addCollectionView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.inputImage.image = UIImage(named: photoArray[indexPath.row])
        return cell
    }
}
