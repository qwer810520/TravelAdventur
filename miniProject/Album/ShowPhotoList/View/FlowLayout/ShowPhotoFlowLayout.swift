//
//  ShowPhotoFlowLayout.swift
//  miniProject
//
//  Created by Min on 2020/2/6.
//  Copyright © 2020 楷岷 張. All rights reserved.
//

import UIKit

class ShowPhotoFlowLayout: UICollectionViewFlowLayout {

  private var collectionViewHeight: CGFloat {
    return collectionView?.frame.height ?? 0
  }
  private var collectionViewWidth: CGFloat {
    return collectionView?.frame.width ?? 0
  }

  private var cellWidth: CGFloat {
    return (collectionViewWidth - (space * 4)) / 3
  }

  var space: CGFloat {
    return 10
  }

  override func prepare() {
    super.prepare()
    scrollDirection = .vertical
    itemSize = CGSize(width: cellWidth, height: cellWidth)
    sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    minimumLineSpacing = space
    minimumInteritemSpacing = space
  }
}
