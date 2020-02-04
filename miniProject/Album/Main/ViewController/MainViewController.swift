//
//  MainViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/14.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit

class MainViewController: ParentViewController {
    
    fileprivate var albumList = [AlbumModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = StickyCollectionViewFlowLayout()
        layout.firstItemTransform = 0.05
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: (UIScreen.main.bounds.width - 60) * 0.8375)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ShowAlbumDetailCollectionViewCell.self, forCellWithReuseIdentifier: ShowAlbumDetailCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlbumList()
        UIScreen.main.brightness = (UserDefaults.standard.object(forKey: UserDefaultsKey.screenBrightness.rawValue) as? CGFloat) ?? 0.5
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Travel Adventur", barButtonType: ._Add)
        view.addSubview(collectionView)
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navigationHeight)-[collectionView]|",
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
    
    private func getAlbumList() {
        startLoading()
        FirebaseManager2.shared.getAlbumData { [weak self] (albumList, error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(title: error?.localizedDescription ?? "")
                return
            }
            self?.albumList = albumList
        }
    }
    
    // MARK: - Action Method
    
    override func addButtonDidPressed() {
        let vc = TANavigationController(rootViewController: AddAlbunViewController()) 
        present(vc, animated: true, completion: nil)
    }
}

    // MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LocationViewController()
        vc.selectAlbum = albumList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

    // MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailCell = collectionView.dequeueReusableCell(with: ShowAlbumDetailCollectionViewCell.self, for: indexPath)
        detailCell.imageView.image = nil
        detailCell.albumModel = albumList[indexPath.row]
        return detailCell
    }
}
