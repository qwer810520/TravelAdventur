//
//  AddMobilePhotosPresenter.swift
//  miniProject
//
//  Created by Min on 2020/2/12.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit
import Photos

protocol AddMobilePhotosPresenterDelegate: BasePresenterDelegate {
  func dismissVC()
  func addButtonIsHidden(fromStatus status: Bool)
}

class AddMobilePhotosPresenter: NSObject {

  weak var delegate: AddMobilePhotosPresenterDelegate?
  private(set) var mobilePhotoList = [MobilePhotoModel]()
  private(set) var placeData = PlaceModel()

  init(placeData: PlaceModel, delegate: AddMobilePhotosPresenterDelegate? = nil) {
    self.delegate = delegate
    self.placeData = placeData
    super.init()
  }

  func didSelectItem(with index: Int) {
    mobilePhotoList[index].isSelect.toggle()
    delegate?.refreshUI()
    delegate?.addButtonIsHidden(fromStatus: mobilePhotoList.allSatisfy { !$0.isSelect })
  }

  // MARK: - API Methods

  func queryPhotos() {
    delegate?.showIndicator()
    DispatchQueue.global().async { [weak self] in
      let imageManager = PHImageManager.default()
      let requestOptions = PHImageRequestOptions()
      requestOptions.isSynchronous = true
      requestOptions.deliveryMode = .highQualityFormat
      let fetchOptions = PHFetchOptions()
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
      let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
      guard fetchResult.count > 0 else {
        self?.delegate?.dismissIndicator()
        return
      }
      for i in 0..<fetchResult.count {
        imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) {  (image, _) in
          self?.mobilePhotoList.append(MobilePhotoModel(image: image))
        }
      }
      self?.delegate?.dismissIndicator()
      self?.delegate?.refreshUI()
    }
  }

  func uploadPhotoData() {
    let photosList = mobilePhotoList.filter { $0.isSelect }
    
    delegate?.showIndicator()
    FirebaseManager.shared.savePhotoListData(placeID: placeData.placeID, photoList: photosList) { [weak self] result in
      self?.delegate?.dismissIndicator()
      switch result {
        case .success:
          self?.delegate?.dismissVC()
        case .failure(let error):
          self?.delegate?.presentAlert(with: error.localizedDescription, message: nil, checkAction: nil, cancelTitle: nil, cancelAction: nil)
      }
    }
  }
}
