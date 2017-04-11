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
    var testPhotoArray:Array<UIImage> = []
    
    @IBAction func addPhotos(_ sender: UIBarButtonItem) {
        UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePicker, animated: true, completion: nil)
    }
 
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            testPhotoArray.append(picture)
        }
        dismiss(animated: true, completion: nil)
        
    }
}
