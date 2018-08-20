//
//  MainViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/14.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MainViewController: ParentViewController, UICollectionViewDelegateFlowLayout {
    
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = StickyCollectionViewFlowLayout()
        layout.firstItemTransform = 0.05
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: (UIScreen.main.bounds.width - 60) * 0.8375)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AlbumPhotoCollectionCell.self, forCellWithReuseIdentifier: AlbumPhotoCollectionCell.identifier)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()
        UserDefaults.standard.set(UIScreen.main.brightness, forKey: UserDefaultsKey.ScreenBrightness.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIScreen.main.brightness = UserDefaults.standard.object(forKey: UserDefaultsKey.ScreenBrightness.rawValue) as! CGFloat
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "首頁", barButtonType: ._Add)
        view.addSubview(collectionView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[collectionView]|",
            options: [],
            metrics: nil,
            views: ["collectionView": collectionView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            options: [],
            metrics: nil,
            views: ["collectionView": collectionView]))
    }
    
    // MARK: - API Method
    
    private func getUserProfile() {
        guard isNetworkConnected() else { return }
        startLoading()
        FirebaseManager.shared.getUserProfile { [weak self] (error) in
            guard error == nil else {
                self?.showAlert(type: .check, title: (error?.localizedDescription)!)
                return
            }
            self?.stopLoading()
        }
    }
    
    // MARK: - Action Method
    
    override func addButtonDidPressed() {
        
    }
}

    // MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

    // MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumCollectionViewCell
        
        return cell
    }
}
