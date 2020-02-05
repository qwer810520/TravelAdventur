//
//  ShowPhotoListViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/27.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit
import TRMosaicLayout

class ShowPhotoListViewController: ParentViewController {
    
    var placeData: PlaceModel?
    fileprivate var photoURLList = [String]() {
        didSet {
            showPhotosCollectionView.reloadData()
        }
    }
    
    lazy private var showPhotosCollectionView: UICollectionView = {
        let mosaicLayout = TRMosaicLayout()
        mosaicLayout.delegate = self
        let view = UICollectionView(frame: .zero, collectionViewLayout: mosaicLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(ShowPhotosCollectionViewCell.self, forCellWithReuseIdentifier: ShowPhotosCollectionViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPhotoList()
        setUserUnterface()
    }
    
    // MARK: - private Method
    
    private func setUserUnterface() {
        setNavigation(title: "Photos", barButtonType: .back_add)
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        view.addSubview(showPhotosCollectionView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            options: [],
            metrics: nil,
            views: ["collectionView": showPhotosCollectionView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navigationHeight)-[collectionView]-50-|",
            options: [],
            metrics: nil,
            views: ["collectionView": showPhotosCollectionView]))
    }
    
    // MARK: - API Method
    
    private func getPhotoList() {
        guard let placeInfo = placeData else { return }
        FirebaseManager2.shared.getPlaceData(id: placeInfo.placeID) { [weak self] (placeData, error) in
            guard error == nil else {
                self?.showAlert(title: error?.localizedDescription ?? "")
                return
            }
            
            guard !placeData.photoList.isEmpty else { return }
            self?.photoURLList = placeData.photoList
        }
    }
    
    // MARK: - Action Method
    
    override func addButtonDidPressed() {
        let vc = TANavigationController(rootViewController: AddMobilePhotosViewController())
        guard let addPhotoVC = vc.viewControllers.first as? AddMobilePhotosViewController else { return }
        addPhotoVC.placeData = placeData
        present(vc, animated: true, completion: nil)
    }
}

    // MARK: - UICollectionViewDataSource

extension ShowPhotoListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ShowPhotosCollectionViewCell.self, for: indexPath)
        cell.imageURL = photoURLList[indexPath.row]
        return cell
    }
}

    // MARK: - TRMosaicLayoutDelegate

extension ShowPhotoListViewController: TRMosaicLayoutDelegate {
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
