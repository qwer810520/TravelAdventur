//
//  AddMobilePhotosViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import Photos

class AddMobilePhotosViewController: ParentViewController {
    
    lazy private var showMobilePhotoCollectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 2, height: (UIScreen.main.bounds.width / 3) - 2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.allowsMultipleSelection = true
        view.register(ShowMobilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: ShowMobilePhotoCollectionViewCell.identifier)
        return view
    }()
    
    lazy private var addPhotoButton: AddPhotoButton = {
        let button = AddPhotoButton()
        button.addTarget(self, action: #selector(addPhotoButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    var placeData: PlaceModel?
    fileprivate var mobilePhotoList = [MobilePhotoModel]() {
        didSet {
            showMobilePhotoCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        grabPhotos()
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Add Photo", barButtonType: .Dismiss_)
        serAutoLayout()
    }
    
    private func serAutoLayout() {
        view.addSubviews([showMobilePhotoCollectionView, addPhotoButton])
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            options: [],
            metrics: nil,
            views: ["collectionView": showMobilePhotoCollectionView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(getNaviHeight())-[collectionView]|",
            options: [],
            metrics: nil,
            views: ["collectionView": showMobilePhotoCollectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[button(70)]-20-|",
            options: [],
            metrics: nil,
            views: ["button": addPhotoButton]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[button(70)]-20-|",
            options: [],
            metrics: nil,
            views: ["button": addPhotoButton]))
    }
    
    private func grabPhotos() {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard fetchResult.count > 0 else { return }
        
        for i in 0..<fetchResult.count {
            imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { [weak self] (image, error) in
                self?.mobilePhotoList.append(MobilePhotoModel(image: image!))
            }
        }
        
        showMobilePhotoCollectionView.reloadData()
    }
    
    // MARK: - Action Method
    
    @objc private func addPhotoButtonDidPressed() {
        let addPhotosList = mobilePhotoList.filter { $0.isSelect }
        
        guard isNetworkConnected() else { return }
        
        guard !addPhotosList.isEmpty else {
            showAlert(type: .check, title: "請選擇要上傳的相片")
            return
        }
        
        startLoading()
        FirebaseManager.shared.savePhotoListData(placeID: (placeData?.placeID)!, photoList: addPhotosList) { [weak self] (error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(type: .check, title: (error?.localizedDescription)!)
                return
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

    // MARK: - UICollectionViewDelegate

extension AddMobilePhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mobilePhotoList[indexPath.row].isSelect = mobilePhotoList[indexPath.row].isSelect ? false : true
        collectionView.reloadData()
    }
}

    // MARK: - UICollectionViewDataSource

extension AddMobilePhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mobilePhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowMobilePhotoCollectionViewCell.identifier, for: indexPath) as! ShowMobilePhotoCollectionViewCell
        cell.imageView.image = mobilePhotoList[indexPath.row].image
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = mobilePhotoList[indexPath.row].isSelect ? TAStyle.orange.cgColor : UIColor.clear.cgColor
        return cell
    }
}
