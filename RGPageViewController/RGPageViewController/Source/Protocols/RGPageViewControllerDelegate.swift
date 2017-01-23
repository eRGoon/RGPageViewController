//
//  RGPageViewControllerDelegate.swift
//  RGPageViewController
//
//  Created by Ronny Gerasch on 23.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

// MARK: - RGPageViewControllerDelegate
@objc public protocol RGPageViewControllerDelegate {
  /// Delegate objects can implement this method if want to be informed when a page changed.
  ///
  /// - parameter index: the index of the active page
  @objc optional func willChangePageToIndex(_ index: Int, fromIndex from: Int)
  
  /// Delegate objects can implement this method if want to be informed when a page changed.
  ///
  /// - parameter index: the index of the active page
  @objc optional func didChangePageToIndex(_ index: Int)
  
  /// Delegate objects can implement this method if tabs use dynamic width.
  ///
  /// - parameter index: the index of the tab
  /// - returns: the width for the tab at the given index
  @objc optional func widthForTabAtIndex(_ index: Int) -> CGFloat
  
  /// Delegate objects can implement this method if tabs use dynamic height.
  ///
  /// - parameter index: the index of the tab
  /// - returns: the height for the tab at the given index
  @objc optional func heightForTabAtIndex(_ index: Int) -> CGFloat
}
