//
//  RGPageViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 08.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

enum RGTabbarStyle {
    case Solid
    case Blurred
}
enum RGTabStyle {
    case None
    case InactiveFaded
}
enum RGTabbarPosition {
    case Top
    case Bottom
    case Left
    case Right
}

class RGPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, UIToolbarDelegate {
    // protocols
    weak var datasource: RGPageViewControllerDataSource?
    weak var delegate: RGPageViewControllerDelegate?
    var pageViewScrollDelegate: UIScrollViewDelegate?
    
    // variables
    var animatingToTab: Bool = false
    var needsSetup: Bool = true
    var needsLayoutSubviews = true
    // pager
    var pageViewControllers: NSMutableArray = NSMutableArray()
    var pageCount: Int! = 0
    var currentPageIndex: Int = 0
    var pager: UIPageViewController!
    var pagerOrientation: UIPageViewControllerNavigationOrientation {
        get {
            return .Horizontal
        }
    }
    var pagerView: UIView?
    var pagerScrollView: UIScrollView?
    // tabs
    var tabs: NSMutableArray = NSMutableArray()
    var currentTabIndex: Int = 0
    var tabWidth: CGFloat = UIScreen.mainScreen().bounds.size.width / 3.0
    var tabbarWidth: CGFloat = 100.0
    var tabbarHeight: CGFloat = 38.0
    var tabIndicatorWidthOrHeight: CGFloat = 2.0
    var tabIndicatorColor: UIColor = UIColor.lightGrayColor()
    var tabMargin: CGFloat = 0.0
    var tabStyle: RGTabStyle {
        get {
            return .None
        }
    }
    // tabbar
    var tabbarStyle: RGTabbarStyle {
        get {
            return .Blurred
        }
    }
    var tabbarPosition: RGTabbarPosition {
        get {
            return .Top
        }
    }
    var tabbar: UIView!
    var barTintColor: UIColor?
    var tabScrollView: UIScrollView = UIScrollView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.initSelf()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.needsSetup {
            self.setupSelf()
        }
    }
    
    override func viewWillLayoutSubviews() {
        if self.needsLayoutSubviews {
            self.layoutSubviews()
            self.selectTabAtIndex(self.currentTabIndex)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func layoutSubviews() {
        var constraints: NSMutableArray!
        
        switch self.tabbarPosition {
        case .Top:
            constraints = layoutTabbarTop()
        case .Bottom:
            constraints = layoutTabbarBottom()
        case .Left:
            constraints = layoutTabbarLeft()
        case .Right:
            constraints = layoutTabbarRight()
        }
        
        self.view.addConstraints(constraints)
        
        self.needsLayoutSubviews = false
    }
    
    private func layoutTabbarTop() -> NSMutableArray {
        let constraints: NSMutableArray = NSMutableArray()
        
        // remove hairline image in navigation bar if attached to top
        if let navController = self.navigationController {
            navController.navigationBar.hideHairline()
        }
        
        // tabbar constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.tabbarHeight))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabbar scrollView constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabpager constraints
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        return constraints
    }
    
    private func layoutTabbarBottom() -> NSMutableArray {
        let constraints: NSMutableArray = NSMutableArray()
        
        // tabbar constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.tabbarHeight))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabbar scrollView constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabpager constraints
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        return constraints
    }
    
    private func layoutTabbarLeft() -> NSMutableArray {
        let constraints: NSMutableArray = NSMutableArray()
        
        // scroll tabbar under topbar if using solid style
        if self.tabbarStyle == RGTabbarStyle.Solid {
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))

            var edgeInsets: UIEdgeInsets = self.tabScrollView.contentInset
            
            edgeInsets.top = self.topLayoutGuide.length
            edgeInsets.bottom = self.bottomLayoutGuide.length
            
            self.tabScrollView.contentInset = edgeInsets
            self.tabScrollView.scrollIndicatorInsets = edgeInsets
        } else {
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        }
        
        // tabbar constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.tabbarWidth))
        
        // tabbar scrollView constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabpager constraints
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        return constraints
    }
    
    private func layoutTabbarRight() -> NSMutableArray {
        let constraints: NSMutableArray = NSMutableArray()
        
        // scroll tabbar under topbar if using solid style
        if self.tabbarStyle == RGTabbarStyle.Solid {
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
            
            var edgeInsets: UIEdgeInsets = self.tabScrollView.contentInset
            
            edgeInsets.top = self.topLayoutGuide.length
            edgeInsets.bottom = self.bottomLayoutGuide.length
            
            self.tabScrollView.contentInset = edgeInsets
            self.tabScrollView.scrollIndicatorInsets = edgeInsets
        } else {
            constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        }
        
        // tabbar constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.tabbarWidth))
        constraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        
        // tabbar scrollView constraints
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabpager constraints
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        
        return constraints
    }
    
    private func initSelf() {
        // init pager
        self.pager = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: self.pagerOrientation, options: nil)
        
        // init tabbar
        switch self.tabbarStyle {
        case .Blurred:
            self.tabbar = UIToolbar(frame: CGRectZero)
        case .Solid:
            self.tabbar = UIView(frame: CGRectZero)
        }
        
        self.addChildViewController(self.pager)
        
        self.pagerView = self.pager.view
        self.pagerScrollView = self.pagerView!.subviews[0] as? UIScrollView
        self.pageViewScrollDelegate = self.pagerScrollView?.delegate
        
        self.pagerScrollView!.scrollsToTop = false
        self.pagerScrollView!.delegate = self
        
        self.pager.dataSource = self
        self.pager.delegate = self
        
        self.animatingToTab = false
        self.needsSetup = true
    }
    
    private func setupSelf() {
        for tabView in self.tabs {
            (tabView as RGTabView).removeFromSuperview()
        }
        
        self.tabScrollView.contentSize = CGSizeZero
        
        self.tabs.removeAllObjects()
        self.pageViewControllers.removeAllObjects()
        
        if let theSource = self.datasource {
            self.pageCount = theSource.numberOfPagesForViewController(self)
        }
        
        self.tabs = NSMutableArray(capacity: self.pageCount)
        self.pageViewControllers = NSMutableArray(capacity: self.pageCount)
        
        for i in 0 ..< self.pageCount {
            self.tabs.addObject(NSNull())
            self.pageViewControllers.addObject(NSNull())
        }
        
        // init Tabbar
        if let theDelegate = self.delegate {
            if let tabHeight = theDelegate.heightForTabbar?() {
                self.tabbarHeight = tabHeight
            }
            
            if let tabWidth = theDelegate.widthForTabbar?() {
                self.tabbarWidth = tabWidth
            }
            
            if let indicatorColor = theDelegate.colorForTabIndicator?() {
                self.tabIndicatorColor = indicatorColor
            }
            
            if let indicatorHW = theDelegate.widthOrHeightForIndicator?() {
                self.tabIndicatorWidthOrHeight = indicatorHW
            }
            
            if let tintColor = theDelegate.tintColorForTabBar?() {
                self.barTintColor = tintColor
                
                switch self.tabbarStyle {
                case .Blurred:
                    (self.tabbar as UIToolbar).barTintColor = self.barTintColor
                case .Solid:
                    self.tabbar.backgroundColor = self.barTintColor
                }
            }
        }
        
        var tabScrollFrame: CGRect = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.tabbarHeight)
        
        switch self.tabbarPosition {
        case .Top, .Bottom:
            tabScrollFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.tabbarHeight)
        case .Left, .Right:
            tabScrollFrame = CGRectMake(0.0, 0.0, self.tabbarWidth, self.view.bounds.size.height)
        }
        
        self.tabScrollView.frame = tabScrollFrame
        self.tabScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tabScrollView.backgroundColor = UIColor.clearColor()
        self.tabScrollView.scrollsToTop = false
        self.tabScrollView.opaque = false
        self.tabScrollView.showsHorizontalScrollIndicator = false
        self.tabScrollView.showsVerticalScrollIndicator = false
        
        var contentSizeWH: CGFloat = self.tabMargin / 2.0
        
        for i in 0 ..< self.pageCount {
            if let tabView: RGTabView = self.tabViewAtIndex(i) {
                var frame: CGRect = tabView.frame
                
                switch self.tabbarPosition {
                case .Top, .Bottom:
                    frame.origin.x = contentSizeWH
 
                    contentSizeWH += CGRectGetWidth(frame) + self.tabMargin
                case .Left, .Right:
                    frame.origin.y = contentSizeWH
                    
                    contentSizeWH += CGRectGetHeight(frame) + self.tabMargin
                }
                
                tabView.frame = frame
                
                self.tabScrollView.addSubview(tabView)
                
                var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                
                tabView.addGestureRecognizer(tapRecognizer)
            }
        }
        
        contentSizeWH -= self.tabMargin / 2.0
        
        switch self.tabbarPosition {
        case .Top, .Bottom:
            self.tabScrollView.contentSize = CGSizeMake(contentSizeWH, self.tabbarHeight)
        case .Left, .Right:
            self.tabScrollView.contentSize = CGSizeMake(self.tabbarWidth, contentSizeWH)
        }
        
        if self.tabbarStyle == .Blurred {
            (self.tabbar as UIToolbar).translucent = true
            (self.tabbar as UIToolbar).delegate = self
        }
        
        self.tabbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tabbar.addSubview(self.tabScrollView)
        
        self.pagerView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.pagerView!.autoresizingMask = (UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth)
        
        self.view.addSubview(self.pagerView!)
        self.view.addSubview(self.tabbar)
        
        self.needsSetup = false
    }
    
    private func tabViewAtIndex(index: Int) -> RGTabView? {
        if index >= self.pageCount {
            return nil
        }
        
        if self.tabs.objectAtIndex(index).isEqual(NSNull()) {
            if let tabViewContent: UIView = self.datasource?.tabViewForPageAtIndex(self, index: index) {
                var tabView: RGTabView
                
                switch self.tabbarPosition {
                case .Top, .Bottom:
                    if let theWidth: CGFloat = self.delegate?.widthForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, theWidth, self.tabbarHeight), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .Horizontal)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, self.tabWidth, self.tabbarHeight), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .Horizontal)
                    }
                case .Left:
                    if let theHeight: CGFloat = self.delegate?.heightForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, self.tabbarWidth, theHeight), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .VerticalLeft)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, self.tabbarWidth, self.tabbarWidth), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .VerticalLeft)
                    }
                case .Right:
                    if let theHeight: CGFloat = self.delegate?.heightForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, self.tabbarWidth, theHeight), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .VerticalRight)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, self.tabbarWidth, self.tabbarWidth), indicatorColor: self.tabIndicatorColor, indicatorHW: self.tabIndicatorWidthOrHeight, style: self.tabStyle, orientation: .VerticalRight)
                    }
                }
                
                tabView.addSubview(tabViewContent)
                
                tabView.clipsToBounds = true
                
                tabViewContent.center = tabView.center
                
                self.tabs.replaceObjectAtIndex(index, withObject: tabView)
            }
        }
        
        return self.tabs.objectAtIndex(index) as? RGTabView
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index >= self.pageCount {
            return nil
        }
        
        if self.pageViewControllers.objectAtIndex(index).isEqual(NSNull()) {
            if let vc: UIViewController = self.datasource?.viewControllerForPageAtIndex(self, index: index) {
                let view: UIView = vc.view.subviews[0] as UIView
                
                if view is UIScrollView {
                    let scrollView = (view as UIScrollView)
                    var edgeInsets: UIEdgeInsets = scrollView.contentInset
                    
                    if self.tabbarPosition == RGTabbarPosition.Top {
                        edgeInsets.top = self.topLayoutGuide.length + self.tabbarHeight
                    } else if self.tabbarPosition == RGTabbarPosition.Bottom {
                        edgeInsets.top = self.topLayoutGuide.length
                        edgeInsets.bottom = self.tabbarHeight
                    } else {
                        edgeInsets.top = self.topLayoutGuide.length
                        edgeInsets.bottom = self.bottomLayoutGuide.length
                    }
                    
                    scrollView.contentInset = edgeInsets
                    scrollView.scrollIndicatorInsets = edgeInsets
                }
                
                self.pageViewControllers.replaceObjectAtIndex(index, withObject: vc)
            }
        }
        
        return self.pageViewControllers.objectAtIndex(index) as? UIViewController
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let tabView: RGTabView = sender.view as RGTabView
        let i: Int = self.tabs.indexOfObject(tabView)
        
        if self.currentTabIndex != i {
            self.selectTabAtIndex(i)
        }
    }
    
    private func selectTabAtIndex(index: Int) {
        if index >= self.pageCount {
            return
        }
        
        self.animatingToTab = true
        
        self.updateTabIndex(index, animated: true)
        self.updatePager(index)
        
        self.delegate?.didChangePageToIndex?(index)
    }
    
    private func updateTabIndex(index: Int, animated: Bool) {
        let activeTab: RGTabView = self.tabViewAtIndex(self.currentTabIndex)!
        let newTab: RGTabView = self.tabViewAtIndex(index)!
        
        activeTab.selected = false
        newTab.selected = true
        
        self.currentTabIndex = index
        
        var visibleRect = newTab.frame
        
        switch self.tabbarPosition {
        case .Top, .Bottom:
            visibleRect.origin.x -= self.tabMargin / 2.0
            visibleRect.size.width += self.tabMargin
        case .Left, .Right:
            visibleRect.origin.y -= self.tabMargin / 2.0
            visibleRect.size.height += self.tabMargin
        }
        
        self.tabScrollView.scrollRectToVisible(visibleRect, animated: animated)
    }
    
    private func updatePager(index: Int) {
        if let vc: UIViewController = self.viewControllerAtIndex(index) {
            weak var weakSelf: RGPageViewController? = self
            weak var weakPager: UIPageViewController? = self.pager
            
            if index == self.currentPageIndex {
                self.pager.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                })
            } else if !(index + 1 == self.currentPageIndex || index - 1 == self.currentPageIndex) {
                self.pager.setViewControllers([vc], direction: index < self.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        weakPager!.setViewControllers([vc], direction: index < weakSelf!.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                    })
                })
            } else {
                self.pager.setViewControllers([vc], direction: index < self.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                })
            }
            
            self.currentPageIndex = index
        }
    }
    
    private func indexForViewController(vc: UIViewController) -> (Int) {
        return self.pageViewControllers.indexOfObject(vc)
    }
    
    // MARK: - Interface rotation
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.selectTabAtIndex(self.currentTabIndex)
    }
    
    // MARK: - UIToolbarDelegate
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        var position: UIBarPosition = UIBarPosition.Top

        switch self.tabbarPosition {
        case .Top:
            position = UIBarPosition.Top
        case .Bottom:
            position = UIBarPosition.Bottom
        case .Left, .Right:
            position = UIBarPosition.Any
        }
        
        return position
    }
    
    // MARK: - PageViewController Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        
        if index == 0 {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        
        if index == self.pageCount - 1 {
            return nil
        }
        
        index++
        
        return self.viewControllerAtIndex(index)
    }
    
    // MARK: - PageViewController Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (finished && completed) {
            let vc: UIViewController = self.pager.viewControllers[0] as UIViewController
            let index: Int = self.indexForViewController(vc)
            
            self.selectTabAtIndex(index)
        }
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let shouldScroll = self.pageViewScrollDelegate?.scrollViewShouldScrollToTop?(scrollView) {
            return shouldScroll
        }
        
        return false
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.pageViewScrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageViewScrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        self.pageViewScrollDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.pageViewScrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        self.pageViewScrollDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if let view: UIView = self.pageViewScrollDelegate?.viewForZoomingInScrollView?(scrollView) {
            return view
        }
        
        return nil
    }
}

// MARK: - RGTabView
class RGTabView: UIView {
    enum RGTabOrientation {
        case Horizontal
        case VerticalLeft
        case VerticalRight
    }
    
    // variables
    var selected: Bool = false {
        didSet {
            if self.subviews[0] is RGTabBarItem {
                (self.subviews[0] as RGTabBarItem).selected = self.selected
            } else {
                if self.style == RGTabStyle.InactiveFaded {
                    if self.selected {
                        self.alpha = 1.0
                    } else {
                        self.alpha = 0.566
                    }
                }
                
                self.setNeedsDisplay()
            }
        }
    }
    var indicatorHW: CGFloat = 2.0
    var indicatorColor: UIColor = UIColor.lightGrayColor()
    var orientation: RGTabOrientation = .Horizontal
    var style: RGTabStyle = .None
    
    init(frame: CGRect, indicatorColor: UIColor, indicatorHW: CGFloat, style: RGTabStyle, orientation: RGTabOrientation) {
        super.init(frame: frame)
        
        self.indicatorColor = indicatorColor
        self.orientation = orientation
        self.indicatorHW = indicatorHW
        self.style = style
        
        self.initSelf()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    func initSelf() {
        self.backgroundColor = UIColor.clearColor()
        
        if self.style == RGTabStyle.InactiveFaded {
            self.alpha = 0.566
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.selected {
            if !(self.subviews[0] is RGTabBarItem) {
                var bezierPath: UIBezierPath = UIBezierPath()
                
                if self.orientation == .Horizontal {
                    bezierPath.moveToPoint(CGPointMake(0.0, CGRectGetHeight(rect) - self.indicatorHW / 2.0))
                    bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - self.indicatorHW / 2.0))
                    bezierPath.lineWidth = self.indicatorHW
                } else if self.orientation == .VerticalLeft {
                    bezierPath.moveToPoint(CGPointMake(self.indicatorHW / 2.0, 0.0))
                    bezierPath.addLineToPoint(CGPointMake(self.indicatorHW / 2.0, CGRectGetHeight(rect)))
                    bezierPath.lineWidth = self.indicatorHW
                } else if self.orientation == .VerticalRight {
                    bezierPath.moveToPoint(CGPointMake(CGRectGetWidth(rect) - (self.indicatorHW / 2.0), 0.0))
                    bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(rect) - (self.indicatorHW / 2.0), CGRectGetHeight(rect)))
                    bezierPath.lineWidth = self.indicatorHW
                }
                
                self.indicatorColor.setStroke()
                
                bezierPath.stroke()
            }
        }
    }
}

// MARK: - RGTabBarItem
class RGTabBarItem: UIView {
    var selected: Bool = false {
        didSet {
            self.setSelectedState()
        }
    }
    var text: String?
    var image: UIImage?
    var textLabel: UILabel?
    var imageView: UIImageView?
    var normalColor: UIColor? = UIColor.grayColor()
    
    init(frame: CGRect, text: String?, image: UIImage?, color: UIColor?) {
        super.init(frame: frame)
        
        self.text = text
        self.image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if color != nil {
            self.normalColor = color
        }
        
        self.initSelf()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    func initSelf() {
        self.backgroundColor = UIColor.clearColor()
        
        if self.image != nil {
            self.imageView = UIImageView(image: self.image)
            
            self.addSubview(self.imageView!)
            
            self.imageView!.tintColor = self.normalColor
            self.imageView!.center.x = self.center.x
            self.imageView!.center.y = self.center.y - 5.0
        }
        
        if self.text != nil {
            self.textLabel = UILabel()
            
            self.textLabel!.numberOfLines = 1
            self.textLabel!.text = self.text
            self.textLabel!.textAlignment = NSTextAlignment.Center
            self.textLabel!.textColor = self.normalColor
            self.textLabel!.font = UIFont.systemFontOfSize(10.0)
            
            self.textLabel!.sizeToFit()
            
            self.textLabel!.frame = CGRectMake(0.0, self.frame.size.height - self.textLabel!.frame.size.height - 3.0, self.frame.size.width, self.textLabel!.frame.size.height)
            
            self.addSubview(self.textLabel!)
        }
    }
    
    func setSelectedState() {
        if self.selected {
            self.textLabel?.textColor = self.tintColor
            self.imageView?.tintColor = self.tintColor
        } else {
            self.textLabel?.textColor = self.normalColor
            self.imageView?.tintColor = self.normalColor
        }
    }
}

// MARK: - UIImage+ColoredImage
extension UIImage {
    class func coloredImage(color: UIColor, size: CGSize, opaque: Bool) -> UIImage? {
        var rect: CGRect = CGRectMake(0.0, 0.0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0.0)
        
        color.setFill()
        
        UIRectFill(rect)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image;
    }
}

// MARK: - UINavigationBar hide Hairline
extension UINavigationBar {
    func hideHairline() {
        if let hairlineView: UIImageView = self.findHairlineImageView(containedIn: self) {
            hairlineView.hidden = true
        }
    }
    
    func findHairlineImageView(containedIn view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView: UIImageView = self.findHairlineImageView(containedIn: subview as UIView) {
                return imageView
            }
        }
        
        return nil
    }
}

// MARK: - RGPageViewController Data Source
@objc protocol RGPageViewControllerDataSource {
    /// Asks dataSource how many pages will there be.
    ///
    /// :param: pageViewController the RGPageViewController instance that's subject to
    ///
    /// :returns: the total number of pages
    func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int
    
    /// Asks dataSource to give a view to display as a tab item.
    ///
    /// :param: pageViewController the RGPageViewController instance that's subject to
    /// :param: index the index of the tab whose view is asked
    ///
    /// :returns: a UIView instance that will be shown as tab at the given index
    func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView
    
    /// The content for any tab. Return a UIViewController instance and RGPageViewController will use its view to show as content.
    ///
    /// :param: pageViewController the RGPageViewController instance that's subject to
    /// :param: index the index of the content whose view is asked
    ///
    /// :returns: a UIViewController instance whose view will be shown as content
    func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController?
}

// MARK: - RGPageViewController Delegate
@objc protocol RGPageViewControllerDelegate {
    /// Delegate objects can implement this method if want to be informed when a page changed.
    ///
    /// :param: index the index of the active page
    optional func didChangePageToIndex(index: Int)
    
    /// Delegate objects can implement this method to set a custom width for the tab view.
    ///
    /// :returns: the width of the tab view
    optional func widthForTabbar() -> CGFloat
    
    /// Delegate objects can implement this method to set a custom height for the tab view.
    ///
    /// :returns: the height of the tab view
    optional func heightForTabbar() -> CGFloat
    
    /// Delegate objects can implement this method to set a custom width or height for the tab indicator.
    ///
    /// :returns: the width or height of the tab indicator
    optional func widthOrHeightForIndicator() -> CGFloat
    
    /// Delegate objects can implement this method if tabs use dynamic width.
    ///
    /// :param: index the index of the tab
    /// :returns: the width for the tab at the given index
    optional func widthForTabAtIndex(index: Int) -> CGFloat
    
    /// Delegate objects can implement this method if tabs use dynamic height.
    ///
    /// :param: index the index of the tab
    /// :returns: the height for the tab at the given index
    optional func heightForTabAtIndex(index: Int) -> CGFloat
    
    /// Delegate objects can implement this method to specify the color of the tab indicator.
    ///
    /// :returns: the color for the tab indicator
    optional func colorForTabIndicator() -> UIColor
    
    /// Delegate objects can implement this method to specify a tint color for the tabbar.
    ///
    /// :returns: the tint color for the tabbar
    optional func tintColorForTabBar() -> UIColor?
}
