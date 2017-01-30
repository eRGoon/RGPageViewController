//
//  ExampleUITabBarViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 29.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit
import RGPageViewController

class ExampleUITabBarViewController: RGPageViewController {
  override var tabbarPosition: RGTabbarPosition {
    return .bottom
  }
  
  override var tabbarHeight: CGFloat {
    return 49
  }
  
  override var barTintColor: UIColor? {
    return navigationController?.navigationBar.barTintColor
  }
  
  fileprivate let titles = [
    "Playlists",
    "Favorites",
    "Movies",
    "Music",
    "Photos",
    "TV Shows"
  ]
  fileprivate let icons = [
    "lists",
    "favorites",
    "movies",
    "music",
    "photos",
    "shows"
  ]
  let indicatorColor = UIColor(red: 1, green: 172 / 255, blue: 69 / 255, alpha: 1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datasource = self
    delegate = self
  }
}

// MARK: - RGPageViewControllerDataSource
extension ExampleUITabBarViewController: RGPageViewControllerDataSource {
  func numberOfPages(for pageViewController: RGPageViewController) -> Int {
    return titles.count
  }
  
  func pageViewController(_ pageViewController: RGPageViewController, tabViewForPageAt index: Int) -> UIView {
    let title: String = titles[index]
    let tabView: RGTabBarItem = RGTabBarItem(frame: CGRect(x: 0, y: 0, width: view.bounds.width / 6, height: 49), text: title, image: UIImage(named: icons[index]), color: nil)
    
    tabView.tintColor = indicatorColor
    
    return tabView
  }
  
  func pageViewController(_ pageViewController: RGPageViewController, viewControllerForPageAt index: Int) -> UIViewController? {
    if (titles.count == 0) || (index >= titles.count) {
      return nil
    }
    
    let sectionViewController = storyboard!.instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
    
    sectionViewController.sectionTitle = titles[index]
    sectionViewController.imageName = icons[index]
    sectionViewController.color = indicatorColor
    
    return sectionViewController
  }
}

// MARK: - RGPageViewController Delegate
extension ExampleUITabBarViewController: RGPageViewControllerDelegate {
  // use this to set a custom width for a tab
  func pageViewController(_ pageViewController: RGPageViewController, widthForTabAt index: Int) -> CGFloat {
    return view.bounds.size.width / 6
  }
}
