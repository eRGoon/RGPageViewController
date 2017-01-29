//
//  ExampleBottomBarViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 28.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit
import RGPageViewController

class ExampleBottomBarViewController: RGPageViewController {
  override var pagerOrientation: UIPageViewControllerNavigationOrientation {
    return .horizontal
  }
  
  override var tabbarPosition: RGTabbarPosition {
    return .bottom
  }
  
  override var tabbarStyle: RGTabbarStyle {
    return .blurred
  }
  
  override var tabIndicatorColor: UIColor {
    return UIColor.white
  }
  
  override var barTintColor: UIColor? {
    return navigationController?.navigationBar.barTintColor
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
}

// MARK: - RGPageViewControllerDataSource
extension ExampleBottomBarViewController: RGPageViewControllerDataSource {
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
extension ExampleBottomBarViewController: RGPageViewControllerDelegate {
  // use this to set a custom width for a tab
  func widthForTabAtIndex(_ index: Int) -> CGFloat {
    var tabSize = (movies[index]["title"] as! String).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
    
    tabSize.width += 32
    
    return tabSize.width
  }
}
