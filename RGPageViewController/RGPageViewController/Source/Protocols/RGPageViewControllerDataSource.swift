//
//  RGPageViewControllerDataSource.swift
//  RGPageViewController
//
//  Created by Ronny Gerasch on 23.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

// MARK: - RGPageViewControllerData Source
@objc public protocol RGPageViewControllerDataSource {
  /// Asks dataSource how many pages will there be.
  ///
  /// - parameter pageViewController: the RGPageViewController instance that's subject to
  ///
  /// - returns: the total number of pages
  func numberOfPagesForViewController(_ pageViewController: RGPageViewController) -> Int
  
  /// Asks dataSource to give a view to display as a tab item.
  ///
  /// - parameter pageViewController: the RGPageViewController instance that's subject to
  /// - parameter index: the index of the tab whose view is asked
  ///
  /// - returns: a UIView instance that will be shown as tab at the given index
  func tabViewForPageAtIndex(_ pageViewController: RGPageViewController, index: Int) -> UIView
  
  /// The content for any tab. Return a UIViewController instance and RGPageViewController will use its view to show as content.
  ///
  /// - parameter pageViewController: the RGPageViewController instance that's subject to
  /// - parameter index: the index of the content whose view is asked
  ///
  /// - returns: a UIViewController instance whose view will be shown as content
  func viewControllerForPageAtIndex(_ pageViewController: RGPageViewController, index: Int) -> UIViewController?
}
