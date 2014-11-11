//
//  RGPageViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 08.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

class RGPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, UIToolbarDelegate {
    // protocols
    weak var datasource: RGPageViewControllerDataSource?
    weak var delegate: RGPageViewControllerDelegate?
    var pageViewScrollDelegate: UIScrollViewDelegate?
    
    // variables
    var animatingToTab: Bool = false
    var needsSetup: Bool = true
    // pages
    var pageViewControllers: NSMutableArray = NSMutableArray()
    var pageCount: Int! = 0
    var currentPageIndex: Int = 0
    var pager: UIPageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
    var pagerView: UIView?
    var pagerScrollView: UIScrollView?
    // tabs
    var tabs: NSMutableArray = NSMutableArray()
    var currentTabIndex: Int = 0
    var tabWidth: CGFloat = 128.0
    var tabHeight: CGFloat = 38.0
    var tabIndicatorHeight: CGFloat = 2.0
    var tabIndicatorColor: UIColor = UIColor.lightGrayColor()
    // tabbar
    var tabbar: UIToolbar = UIToolbar(frame: CGRectZero)
    var barTintColor: UIColor?
    var tabbarPosition: UIBarPosition = UIBarPosition.TopAttached
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
        self.layoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func layoutSubviews() {
        let viewConstraints: NSMutableArray = NSMutableArray()
        
        // add constraints
        // tabbar constraints
        if self.tabbarPosition == UIBarPosition.Top || self.tabbarPosition == UIBarPosition.TopAttached {
            // remove hairline image in navigation bar
            if self.topLayoutGuide.length == 64.0 {
                let navBar: UINavigationBar? = self.navigationController?.navigationBar
                
                if navBar != nil {
                    let hairlineView: UIImageView? = self.findHairlineImageView(containedIn: navBar!)
                    
                    hairlineView?.hidden = true
                }
            }
            
            viewConstraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        } else if self.tabbarPosition == UIBarPosition.Bottom {
            viewConstraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        }
        
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.tabHeight))
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabbar, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabbar scrollView constraints
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.tabScrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabbar, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        // tabpager constraints
        viewConstraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        viewConstraints.addObject(NSLayoutConstraint(item: self.pagerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraints(viewConstraints)
    }
    
    func initSelf() {
        // init pager
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
    
    func setupSelf() {
        for tabView in self.tabs {
            (tabView as RGTabView).removeFromSuperview()
        }
        
        self.tabScrollView.contentSize = CGSizeZero
        
        self.tabs.removeAllObjects()
        self.pageViewControllers.removeAllObjects()
        
        self.pageCount = self.datasource?.numberOfPagesForViewController(self)
        self.tabs = NSMutableArray(capacity: self.pageCount)
        self.pageViewControllers = NSMutableArray(capacity: self.pageCount)
        
        for i in 0 ..< self.pageCount {
            self.tabs.addObject(NSNull())
            self.pageViewControllers.addObject(NSNull())
        }
        
        // init Tabbar
        if (self.delegate?.heightForTabbar? != nil) {
            self.tabHeight = self.delegate!.heightForTabbar!()
        }
        
        if (self.delegate?.colorForTabIndicator? != nil) {
            self.tabIndicatorColor = self.delegate!.colorForTabIndicator!()
        }
        
        if (self.delegate?.heightForIndicator? != nil) {
            self.tabIndicatorHeight = self.delegate!.heightForIndicator!()
        }
        
        if (self.delegate?.tintColorForTabBar? != nil) {
            self.barTintColor = self.delegate!.tintColorForTabBar!()
        }
        
        self.tabScrollView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.tabHeight)
        self.tabScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tabScrollView.backgroundColor = UIColor.clearColor()
        self.tabScrollView.scrollsToTop = false
        self.tabScrollView.opaque = false
        self.tabScrollView.showsHorizontalScrollIndicator = false
        self.tabScrollView.showsVerticalScrollIndicator = false
        
        var contentSizeWidth: CGFloat = 0.0
        
        for i in 0 ..< self.pageCount {
            var tabView: RGTabView = self.tabViewAtIndex(i)!
            var frame: CGRect = tabView.frame
            
            frame.origin.x = contentSizeWidth
            
            tabView.frame = frame
            
            self.tabScrollView.addSubview(tabView)
            
            contentSizeWidth += CGRectGetWidth(frame)
            
            var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            
            tabView.addGestureRecognizer(tapRecognizer)
        }
        
        self.tabScrollView.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight)
        
        if self.barTintColor != nil {
            self.tabbar.barTintColor = self.barTintColor
        }
        self.tabbar.translucent = true
        self.tabbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tabbar.addSubview(self.tabScrollView)
        self.tabbar.delegate = self
        
        self.pagerView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.pagerView!.autoresizingMask = (UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth)
        
        self.view.addSubview(self.pagerView!)
        self.view.addSubview(self.tabbar)
        self.selectTabAtIndex(0)
        
        self.needsSetup = false
    }
    
    func tabViewAtIndex(index: Int) -> RGTabView? {
        if index >= self.pageCount {
            return nil
        }
        
        if self.tabs.objectAtIndex(index).isEqual(NSNull()) {
            var tabViewContent: UIView? = nil
            var tabWidth: CGFloat = self.tabWidth

            tabViewContent = self.datasource?.tabViewForPageAtIndex(self, index: index)
            
            if (self.delegate?.widthForTabAtIndex? != nil) {
                tabWidth = self.delegate!.widthForTabAtIndex!(index)
            }
            
            let tabView: RGTabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabWidth, self.tabHeight), indicatorColor: self.tabIndicatorColor, indicatorHeight: self.tabIndicatorHeight)
            
            tabView.addSubview(tabViewContent!)
            tabView.clipsToBounds = true
            tabView.indicatorHeight = self.tabIndicatorHeight
            tabView.indicatorColor = self.tabIndicatorColor
            
            tabViewContent!.center = tabView.center
            
            self.tabs.replaceObjectAtIndex(index, withObject: tabView)
        }
        
        return self.tabs.objectAtIndex(index) as? RGTabView
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index >= self.pageCount {
            return nil
        }
        
        if self.pageViewControllers.objectAtIndex(index).isEqual(NSNull()) {
            let vc: UIViewController? = self.datasource?.viewControllerForPageAtIndex(self, index: index)
            let view: UIView = vc?.view.subviews[0] as UIView
            
            if view is UIScrollView {
                var edgeInsets: UIEdgeInsets = (view as UIScrollView).contentInset
                
                if self.tabbarPosition == UIBarPosition.Top || self.tabbarPosition == UIBarPosition.TopAttached {
                    edgeInsets.top = self.topLayoutGuide.length + self.tabHeight
                } else if self.tabbarPosition == UIBarPosition.Bottom {
                    edgeInsets.top = self.topLayoutGuide.length
                    edgeInsets.bottom = self.tabHeight
                }
                
                (view as UIScrollView).contentInset = edgeInsets
                (view as UIScrollView).scrollIndicatorInsets = edgeInsets
            }
            
            self.pageViewControllers.replaceObjectAtIndex(index, withObject: vc!)
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
    
    func selectTabAtIndex(index: Int) {
        if index >= self.pageCount {
            return
        }
        
        self.animatingToTab = true
        self.updateTabIndex(index, animated: true)
        self.updatePager(index)
        
        self.delegate?.didChangePageToIndex?(index)
    }
    
    func updateTabIndex(index: Int, animated: Bool) {
        let activeTab: RGTabView = self.tabViewAtIndex(self.currentTabIndex)!
        let newTab: RGTabView = self.tabViewAtIndex(index)!
        
        activeTab.selected = false
        newTab.selected = true
        
        self.currentTabIndex = index
        
        if animated {
            self.tabScrollView.scrollRectToVisible(newTab.frame, animated: true)
        }
    }
    
    func updatePager(index: Int) {
        let vc: UIViewController = self.viewControllerAtIndex(index)!
        
        if index == self.currentPageIndex {
            self.pager.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (Bool) -> Void in
                self.animatingToTab = false
            })
        } else if !(index + 1 == self.currentPageIndex || index - 1 == self.currentPageIndex) {
            self.pager.setViewControllers([vc], direction: index < self.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                self.animatingToTab = false
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pager.setViewControllers([vc], direction: index < self.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                })
            })
        } else {
            self.pager.setViewControllers([vc], direction: index < self.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                self.animatingToTab = false
            })
        }
        
        self.currentPageIndex = index
    }
    
    func indexForViewController(vc: UIViewController) -> (Int) {
        return self.pageViewControllers.indexOfObject(vc)
    }
    
    func findHairlineImageView(containedIn view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            let imageView: UIImageView? = self.findHairlineImageView(containedIn: subview as UIView)
            
            if imageView != nil {
                return imageView
            }
        }
        
        return nil
    }
    
    // MARK: - Interface rotation
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.selectTabAtIndex(self.currentTabIndex)
    }
    
    // MARK: - UIToolbarDelegate
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        if (self.delegate?.positionForTabbar? != nil) {
            self.tabbarPosition = self.delegate!.positionForTabbar!(bar)
        }
        
        return self.tabbarPosition
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
        var result: Bool? = false

        if (self.pageViewScrollDelegate?.scrollViewShouldScrollToTop? != nil) {
            result = self.pageViewScrollDelegate?.scrollViewShouldScrollToTop?(scrollView)
        }
        
        return result!
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
        var view: UIView? = nil
        
        view = self.pageViewScrollDelegate?.viewForZoomingInScrollView?(scrollView)
        
        return view
    }
}

// MARK: - RGTabView
class RGTabView: UIView {
    // variables
    var selected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var indicatorHeight: CGFloat = 2.0
    var indicatorColor: UIColor = UIColor.lightGrayColor()
    
    init(frame: CGRect, indicatorColor: UIColor, indicatorHeight: CGFloat) {
        super.init(frame: frame)
        
        self.indicatorColor = indicatorColor
        self.indicatorHeight = indicatorHeight
        
        self.initSelf()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
    }
    
    func initSelf() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.selected {
            var bezierPath: UIBezierPath = UIBezierPath()
            
            bezierPath.moveToPoint(CGPointMake(0.0, CGRectGetHeight(rect) - 1.0))
            bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - 1.0))
            bezierPath.lineWidth = self.indicatorHeight
            
            self.indicatorColor.setStroke()
            
            bezierPath.stroke()
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
    
    /// Delegate objects can implement this method to set a custom height for the tab view.
    ///
    /// :returns: the height of the tab view
    optional func heightForTabbar() -> CGFloat
    
    /// Delegate objects can implement this method to set a custom height for the tab indicator.
    ///
    /// :returns: the height of the tab indicator
    optional func heightForIndicator() -> CGFloat
    
    /// Delegate objects can implement this method if tabs use dynamic width.
    ///
    /// :param: index the index of the tab
    /// :returns: the width for the tab at the given index
    optional func widthForTabAtIndex(index: Int) -> CGFloat
    
    /// Delegate objects can implement this method to specify the position of the tabbar.
    ///
    /// :param: bar the tabbar
    /// :returns: the position for the tabbar
    optional func positionForTabbar(bar: UIBarPositioning) -> UIBarPosition
    
    /// Delegate objects can implement this method to specify the color of the tab indicator.
    ///
    /// :returns: the color for the tab indicator
    optional func colorForTabIndicator() -> UIColor
    
    /// Delegate objects can implement this method to specify a tint color for the tabbar.
    ///
    /// :returns: the tint color for the tabbar
    optional func tintColorForTabBar() -> UIColor
}