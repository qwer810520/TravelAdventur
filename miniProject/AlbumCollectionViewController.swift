//
//  AlbumCollectionViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/14.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import SVProgressHUD


class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBAction func addAlbumItem(_ sender: UIBarButtonItem) {
        let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController")
        navigationController?.pushViewController(addViewController!, animated: true)
    }
    
    var first = true
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let layout = self.collectionViewLayout as! StickyCollectionViewFlowLayout
        layout.firstItemTransform = 0.05
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if first == true {
            if Library.isInternetOk() == true {
                SVProgressHUD.show(withStatus: "讀取中...")
                FirebaseServer.firebase().loadAllData(getType: .value, completion: { 
                    SVProgressHUD.showSuccess(withStatus: "完成")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                    self.collectionView?.reloadData()
                    self.first = false
                })
            } else {
                present(Library.alertSet(title: "錯誤", message: "網路無法連線，請確認網路是否開啟", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: nil), animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showSVP(Not:)), name: Notification.Name("albumSVP"), object: nil)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseServer.firebase().dataArrayCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumCollectionViewCell
        if FirebaseServer.firebase().dataArrayCount() != 0 {
            cell.titleDetail.isHidden = false
            cell.titleImage.isHidden = false
            cell.titleLabel.isHidden = false
            cell.backView.isHidden = false
            cell.labelBackView.isHidden = false
            cell.backView.layer.cornerRadius = 7
            cell.backView.clipsToBounds = true
            cell.titleLabel.text = FirebaseServer.firebase().dataArray(select: indexPath.row).travelName
            Library.downloadImage(imageViewSet: cell.titleImage, URLString: FirebaseServer.firebase().dataArray(select: indexPath.row).titleImage, completion: { (photo, loading, view) in
                cell.titleImage.image = photo
                loading?.stopAnimating()
                view?.removeFromSuperview()
            })
            cell.titleDetail.text = "\(Library.dateToShowString(date: FirebaseServer.firebase().dataArray(select: indexPath.row).startDate)) ~ \(Library.endDateToShowString(date: FirebaseServer.firebase().dataArray(select: indexPath.row).endDate))"
        } else {
            cell.titleLabel.isHidden = true
            cell.titleImage.isHidden = true
            cell.titleDetail.isEnabled = true
            cell.backView.isHidden = true
            cell.labelBackView.isHidden = true
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FirebaseServer.firebase().saveSelectNumber(num: indexPath.row)
        let googleMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "GoogleMapViewController")
        navigationController?.pushViewController(googleMapViewController!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 55, height: (UIScreen.main.bounds.width - 55) * 0.8375)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
