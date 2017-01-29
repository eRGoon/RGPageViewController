//
//  ExampleTopBarViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 10.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import RGPageViewController
import UIKit

class ExampleTopBarViewController: RGPageViewController {
  override var pagerOrientation: UIPageViewControllerNavigationOrientation {
    return .horizontal
  }
  
  override var tabbarPosition: RGTabbarPosition {
    return .top
  }
  
  override var tabbarStyle: RGTabbarStyle {
    return .blurred
  }
  
  override var tabIndicatorColor: UIColor {
    return UIColor.white
  }
  
  override var barTintColor: UIColor? {
    return self.navigationController?.navigationBar.barTintColor
  }
  
  override var tabStyle: RGTabStyle {
    return .inactiveFaded
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.currentTabIndex = 3
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.currentTabIndex = 3
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datasource = self
    delegate = self
  }
  
  @IBAction func reloadPager(_ sender: UIBarButtonItem) {
    reloadData()
  }
}

// MARK: - RGPageViewControllerDataSource
extension ExampleTopBarViewController: RGPageViewControllerDataSource {
  func numberOfPagesForViewController(_ pageViewController: RGPageViewController) -> Int {
    return movies.count
  }
  
  func tabViewForPageAtIndex(_ pageViewController: RGPageViewController, index: Int) -> UIView {
    let tabView = UILabel()
    
    tabView.font = UIFont.systemFont(ofSize: 17)
    tabView.text = movies[index]["title"] as? String
    tabView.textColor = UIColor.white
    
    tabView.sizeToFit()
    
    return tabView
  }
  
  func viewControllerForPageAtIndex(_ pageViewController: RGPageViewController, index: Int) -> UIViewController? {
    if (movies.count == 0) || (index >= movies.count) {
      return nil
    }
    
    // Create a new view controller and pass suitable data.
    let dataViewController = storyboard!.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
    
    dataViewController.movieData = movies[index]
    
    return dataViewController
  }
}

// MARK: - RGPageViewController Delegate
extension ExampleTopBarViewController: RGPageViewControllerDelegate {
  // use this to set a custom width for a tab
  func widthForTabAtIndex(_ index: Int) -> CGFloat {
    var tabSize = (movies[index]["title"] as! String).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
    
    tabSize.width += 32
    
    return tabSize.width
  }
}
