//
//  RGPageViewController+UICollectionViewDelegate.swift
//  RGPageViewController
//
//  Created by Ronny Gerasch on 23.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

// MARK: - UICollectionViewDelegate
extension RGPageViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if currentTabIndex != indexPath.row {
      selectTabAtIndex(indexPath.row, updatePage: true)
    }
  }
}
