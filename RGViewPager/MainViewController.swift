//
//  MainViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 10.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: RGPageViewController, RGPageViewControllerDataSource, RGPageViewControllerDelegate {
    var tabTitles: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        tabTitles = dateFormatter.monthSymbols

        self.datasource = self
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - RGPageViewController Data Source
    func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int {
        return self.tabTitles.count
    }
    
    func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView {
        let label: UILabel = UILabel()
        let title: String = self.tabTitles.objectAtIndex(index) as String
        
        label.text = title
        label.sizeToFit()
        
        return label
    }
    
    func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController? {
        if (self.tabTitles.count == 0) || (index >= self.tabTitles.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DataViewController") as DataViewController
        
        dataViewController.dataObject = self.tabTitles[index]
        
        return dataViewController
    }
    
    // MARK: - RGPageViewController Delegate
    func widthForTabAtIndex(index: Int) -> CGFloat {
        let tabTitle: NSString = self.tabTitles.objectAtIndex(index) as NSString
        let tabSize: CGSize = tabTitle.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        
        return tabSize.width + 32.0
    }
    
    func positionForTabbar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
    
    func heightForTabbar() -> CGFloat {
        return 44.0
    }
    
    func heightForIndicator() -> CGFloat {
        return 6.0
    }
    
    func colorForTabIndicator() -> UIColor {
        return UIColor(red: 0.84705882352941, green: 0.61960784313725, blue: 0.12941176470588, alpha: 1.0)
    }
    
    func tintColorForTabBar() -> UIColor {
        return UIColor.lightGrayColor()
    }
}