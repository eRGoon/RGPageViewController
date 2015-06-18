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
    //var pagerView: UIView?
    var pagerScrollView: UIScrollView!
    // tabs
    var tabs: NSMutableArray = NSMutableArray()
    var currentTabIndex: Int = 0
    var tabWidth: CGFloat = UIScreen.mainScreen().bounds.size.width / 3.0
    var tabbarWidth: CGFloat {
        get {
            return 100.0
        }
    }
    var tabbarHeight: CGFloat {
        get {
            return 38.0
        }
    }
    var tabIndicatorWidthOrHeight: CGFloat {
        get {
            return 2.0
        }
    }
    var tabIndicatorColor: UIColor {
        get {
            return UIColor.lightGrayColor()
        }
    }
    var tabMargin: CGFloat {
        get {
            return 0.0
        }
    }
    var tabStyle: RGTabStyle {
        get {
            return .None
        }
    }
    // tabbar
    var tabbarHidden: Bool {
        get {
            return false
        }
    }
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
    var barTintColor: UIColor? {
        get {
            return nil
        }
    }
    var tabScrollView: UIScrollView = UIScrollView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        super.loadView()
        
        // init pager
        pager = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: pagerOrientation, options: nil)
        
        addChildViewController(pager)
        
        pagerScrollView = pager.view.subviews[0] as! UIScrollView
        pageViewScrollDelegate = pagerScrollView.delegate
        
        pagerScrollView.scrollsToTop = false
        pagerScrollView.delegate = self
        
        // init tabbar
        switch tabbarStyle {
        case .Blurred:
            tabbar = UIToolbar()
            
            if let bar = tabbar as? UIToolbar {
                bar.barTintColor = barTintColor
                bar.translucent = true
                bar.delegate = self
            }
        case .Solid:
            tabbar = UIView()
            
            tabbar.backgroundColor = barTintColor
        }
        
        tabbar.hidden = tabbarHidden
        
        tabScrollView.backgroundColor = UIColor.clearColor()
        tabScrollView.scrollsToTop = false
        tabScrollView.opaque = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        
        // layout
        switch tabbarPosition {
        case .Top:
            layoutTabbarTop()
        case .Bottom:
            layoutTabbarBottom()
        case .Left:
            layoutTabbarLeft()
        case .Right:
            layoutTabbarRight()
        }
        
        tabbar.addSubview(tabScrollView)
        
        view.addSubview(pager.view)
        view.addSubview(tabbar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if needsSetup {
            setupSelf()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func layoutTabbarTop() {
        tabbar.autoresizingMask = .FlexibleWidth
        tabScrollView.autoresizingMask = .FlexibleWidth
        pager.view.autoresizingMask = (UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth)
        
        var barTop: CGFloat = 20
        
        // remove hairline image in navigation bar if attached to top
        if let navController = navigationController where !navController.navigationBar.hidden {
            barTop = 64
            
            navController.navigationBar.hideHairline()
        }
        
        let tabbarFrame = CGRect(x: 0, y: barTop, width: view.bounds.size.width, height: tabbarHidden ? 0 : tabbarHeight)
        
        tabbar.frame = tabbarFrame
        
        let tabScrollerFrame = CGRect(x: 0, y: 0, width: tabbarFrame.size.width, height: tabbarFrame.size.height)
        
        tabScrollView.frame = tabScrollerFrame
        
        let pagerFrame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        
        pager.view.frame = pagerFrame
    }
    
    private func layoutTabbarBottom() {
        tabbar.autoresizingMask = .FlexibleWidth
        tabScrollView.autoresizingMask = .FlexibleWidth
        pager.view.autoresizingMask = (UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth)
        
        let tabbarFrame = CGRect(x: 0, y: view.bounds.size.height - tabbarHeight, width: view.bounds.size.width, height: tabbarHidden ? 0 : tabbarHeight)
        
        tabbar.frame = tabbarFrame
        
        let tabScrollerFrame = CGRect(x: 0, y: 0, width: tabbarFrame.size.width, height: tabbarFrame.size.height)
        
        tabScrollView.frame = tabScrollerFrame
        
        let pagerFrame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        
        pager.view.frame = pagerFrame
    }
    
    private func layoutTabbarLeft() {
        tabbar.autoresizingMask = .FlexibleHeight
        tabScrollView.autoresizingMask = .FlexibleHeight
        pager.view.autoresizingMask = (.FlexibleHeight | .FlexibleWidth)
        
        var barTop: CGFloat = 0
        
        // scroll tabbar under topbar if using solid style
        if tabbarStyle == .Solid {
            var scrollTop: CGFloat = 20
            
            if let navController = navigationController where !navController.navigationBar.hidden {
                scrollTop = 64
            }
            
            var edgeInsets: UIEdgeInsets = tabScrollView.contentInset
            
            edgeInsets.top = scrollTop
            edgeInsets.bottom = 0
            
            tabScrollView.contentInset = edgeInsets
            tabScrollView.scrollIndicatorInsets = edgeInsets
        } else {
            barTop = 20
            
            if let navController = navigationController where !navController.navigationBar.hidden {
                barTop = 64
            }
        }
        
        let tabbarFrame = CGRect(x: 0, y: barTop, width: tabbarHidden ? 0 : tabbarWidth, height: view.bounds.size.height - barTop)
        
        tabbar.frame = tabbarFrame
        
        let tabScrollerFrame = CGRect(x: 0, y: 0, width: tabbarFrame.size.width, height: tabbarFrame.size.height)
        
        tabScrollView.frame = tabScrollerFrame
        
        let pagerFrame = CGRect(x: tabbarHidden ? 0 : tabbarWidth, y: 0, width: view.bounds.size.width - (tabbarHidden ? 0 : tabbarWidth), height: view.bounds.size.height)
        
        pager.view.frame = pagerFrame
    }
    
    private func layoutTabbarRight() {
        tabbar.autoresizingMask = .FlexibleHeight
        tabScrollView.autoresizingMask = .FlexibleHeight
        pager.view.autoresizingMask = (.FlexibleHeight | .FlexibleWidth)
        
        var barTop: CGFloat = 0
        
        // scroll tabbar under topbar if using solid style
        if tabbarStyle == .Solid {
            var scrollTop: CGFloat = 20
            
            if let navController = navigationController where !navController.navigationBar.hidden {
                scrollTop = 64
            }
            
            var edgeInsets: UIEdgeInsets = tabScrollView.contentInset
            
            edgeInsets.top = scrollTop
            edgeInsets.bottom = 0
            
            tabScrollView.contentInset = edgeInsets
            tabScrollView.scrollIndicatorInsets = edgeInsets
        } else {
            barTop = 20
            
            if let navController = self.navigationController where !navController.navigationBar.hidden {
                barTop = 64
            }
        }
        
        let tabbarFrame = CGRect(x: view.bounds.size.width - tabbarWidth, y: barTop, width: tabbarHidden ? 0 : tabbarWidth, height: view.bounds.size.height - barTop)
        
        tabbar.frame = tabbarFrame
        
        let tabScrollerFrame = CGRect(x: 0, y: 0, width: tabbarFrame.size.width, height: tabbarFrame.size.height)
        
        tabScrollView.frame = tabScrollerFrame
        
        let pagerFrame = CGRect(x: 0, y: 0, width: view.bounds.size.width - (tabbarHidden ? 0 : tabbarWidth), height: view.bounds.size.height)
        
        pager.view.frame = pagerFrame
    }
    
    private func setupSelf() {
        for tabView in tabs {
            (tabView as! RGTabView).removeFromSuperview()
        }
        
        tabScrollView.contentSize = CGSizeZero
        
        tabs.removeAllObjects()
        pageViewControllers.removeAllObjects()
        
        if let theSource = datasource {
            pageCount = theSource.numberOfPagesForViewController(self)
        }
        
        tabs = NSMutableArray(capacity: pageCount)
        pageViewControllers = NSMutableArray(capacity: pageCount)
        
        for i in 0 ..< pageCount {
            tabs.addObject(NSNull())
            pageViewControllers.addObject(NSNull())
        }
        
        var contentSizeWH: CGFloat = tabMargin / 2.0
        
        for i in 0 ..< pageCount {
            if let tabView: RGTabView = tabViewAtIndex(i) {
                var frame: CGRect = tabView.frame
                
                switch tabbarPosition {
                case .Top, .Bottom:
                    frame.origin.x = contentSizeWH
 
                    contentSizeWH += CGRectGetWidth(frame) + tabMargin
                case .Left, .Right:
                    frame.origin.y = contentSizeWH
                    
                    contentSizeWH += CGRectGetHeight(frame) + tabMargin
                }
                
                tabView.frame = frame
                
                tabScrollView.addSubview(tabView)
                
                var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                
                tabView.addGestureRecognizer(tapRecognizer)
            }
        }
        
        contentSizeWH -= tabMargin / 2.0
        
        switch tabbarPosition {
        case .Top, .Bottom:
            tabScrollView.contentSize = CGSizeMake(contentSizeWH, tabbarHeight)
        case .Left, .Right:
            tabScrollView.contentSize = CGSizeMake(tabbarWidth, contentSizeWH)
        }
        
        pager.dataSource = self
        pager.delegate = self
        
        selectTabAtIndex(currentTabIndex)
        
        needsSetup = false
    }
    
    private func tabViewAtIndex(index: Int) -> RGTabView? {
        if index >= pageCount {
            return nil
        }
        
        if tabs.objectAtIndex(index).isEqual(NSNull()) {
            if let tabViewContent: UIView = datasource?.tabViewForPageAtIndex(self, index: index) {
                var tabView: RGTabView
                
                switch tabbarPosition {
                case .Top, .Bottom:
                    if let theWidth: CGFloat = delegate?.widthForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, theWidth, tabbarHeight), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .Horizontal)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabWidth, tabbarHeight), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .Horizontal)
                    }
                case .Left:
                    if let theHeight: CGFloat = delegate?.heightForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabbarWidth, theHeight), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .VerticalLeft)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabbarWidth, tabbarWidth), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .VerticalLeft)
                    }
                case .Right:
                    if let theHeight: CGFloat = delegate?.heightForTabAtIndex?(index) {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabbarWidth, theHeight), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .VerticalRight)
                    } else {
                        tabView = RGTabView(frame: CGRectMake(0.0, 0.0, tabbarWidth, tabbarWidth), indicatorColor: tabIndicatorColor, indicatorHW: tabIndicatorWidthOrHeight, style: tabStyle, orientation: .VerticalRight)
                    }
                }
                
                tabView.addSubview(tabViewContent)
                
                tabView.clipsToBounds = true
                
                tabViewContent.center = tabView.center
                
                tabs.replaceObjectAtIndex(index, withObject: tabView)
            }
        }
        
        return tabs.objectAtIndex(index) as? RGTabView
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index >= pageCount {
            return nil
        }
        
        if pageViewControllers.objectAtIndex(index).isEqual(NSNull()) {
            if let vc: UIViewController = datasource?.viewControllerForPageAtIndex(self, index: index) {
                let view: UIView = vc.view.subviews[0] as! UIView
                
                if view is UIScrollView {
                    let scrollView = (view as! UIScrollView)
                    var edgeInsets: UIEdgeInsets = scrollView.contentInset
                    
                    if tabbarPosition == RGTabbarPosition.Top {
                        edgeInsets.top = tabbar.frame.origin.y + tabbarHeight
                    } else if tabbarPosition == RGTabbarPosition.Bottom {
                        edgeInsets.top = tabbar.frame.origin.y
                        edgeInsets.bottom = tabbarHeight
                    } else {
                        edgeInsets.top = tabbar.frame.origin.y
                        edgeInsets.bottom = 0
                    }
                    
                    scrollView.contentInset = edgeInsets
                    scrollView.scrollIndicatorInsets = edgeInsets
                }
                
                pageViewControllers.replaceObjectAtIndex(index, withObject: vc)
            }
        }
        
        return pageViewControllers.objectAtIndex(index) as? UIViewController
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let tabView: RGTabView = sender.view as! RGTabView
        let i: Int = tabs.indexOfObject(tabView)
        
        if currentTabIndex != i {
            selectTabAtIndex(i)
        }
    }
    
    func selectTabAtIndex(index: Int) {
        if index >= pageCount {
            return
        }
        
        animatingToTab = true
        
        updateTabIndex(index, animated: true)
        updatePager(index)
        
        delegate?.didChangePageToIndex?(index)
    }
    
    private func updateTabIndex(index: Int, animated: Bool) {
        let activeTab: RGTabView = tabViewAtIndex(currentTabIndex)!
        let newTab: RGTabView = tabViewAtIndex(index)!
        
        activeTab.selected = false
        newTab.selected = true
        
        currentTabIndex = index
        
        var visibleRect = newTab.frame
        
        switch tabbarPosition {
        case .Top, .Bottom:
            visibleRect.origin.x -= tabMargin / 2.0
            visibleRect.size.width += tabMargin
        case .Left, .Right:
            visibleRect.origin.y -= tabMargin / 2.0
            visibleRect.size.height += tabMargin
        }
        
        tabScrollView.scrollRectToVisible(visibleRect, animated: animated)
    }
    
    private func updatePager(index: Int) {
        if let vc: UIViewController = viewControllerAtIndex(index) {
            weak var weakSelf: RGPageViewController? = self
            weak var weakPager: UIPageViewController? = pager
            
            if index == currentPageIndex {
                pager.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                })
            } else if !(index + 1 == currentPageIndex || index - 1 == currentPageIndex) {
                pager.setViewControllers([vc], direction: index < currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        weakPager!.setViewControllers([vc], direction: index < weakSelf!.currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                    })
                })
            } else {
                pager.setViewControllers([vc], direction: index < currentPageIndex ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (Bool) -> Void in
                    weakSelf!.animatingToTab = false
                })
            }
            
            currentPageIndex = index
        }
    }
    
    private func indexForViewController(vc: UIViewController) -> (Int) {
        return pageViewControllers.indexOfObject(vc)
    }
    
    func reloadData() {
        for tabView in tabs {
            (tabView as! RGTabView).removeFromSuperview()
        }
        
        tabScrollView.contentSize = CGSizeZero
        
        tabs.removeAllObjects()
        pageViewControllers.removeAllObjects()
        
        if let theSource = datasource {
            pageCount = theSource.numberOfPagesForViewController(self)
        }
        
        tabs = NSMutableArray(capacity: pageCount)
        pageViewControllers = NSMutableArray(capacity: pageCount)
        
        for i in 0 ..< pageCount {
            tabs.addObject(NSNull())
            pageViewControllers.addObject(NSNull())
        }
        
        var contentSizeWH: CGFloat = tabMargin / 2.0
        
        for i in 0 ..< pageCount {
            if let tabView: RGTabView = tabViewAtIndex(i) {
                var frame: CGRect = tabView.frame
                
                switch tabbarPosition {
                case .Top, .Bottom:
                    frame.origin.x = contentSizeWH
                    
                    contentSizeWH += CGRectGetWidth(frame) + tabMargin
                case .Left, .Right:
                    frame.origin.y = contentSizeWH
                    
                    contentSizeWH += CGRectGetHeight(frame) + tabMargin
                }
                
                tabView.frame = frame
                
                tabScrollView.addSubview(tabView)
                
                var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                
                tabView.addGestureRecognizer(tapRecognizer)
            }
        }
        
        contentSizeWH -= tabMargin / 2.0
        
        switch tabbarPosition {
        case .Top, .Bottom:
            tabScrollView.contentSize = CGSizeMake(contentSizeWH, tabbarHeight)
        case .Left, .Right:
            tabScrollView.contentSize = CGSizeMake(tabbarWidth, contentSizeWH)
            
            if tabbarStyle == .Solid {
                var edgeInsets: UIEdgeInsets = tabScrollView.contentInset
                
                edgeInsets.top = topLayoutGuide.length
                edgeInsets.bottom = bottomLayoutGuide.length
                
                tabScrollView.contentInset = edgeInsets
                tabScrollView.scrollIndicatorInsets = edgeInsets
            }
        }
    }
    
    // MARK: - UIToolbarDelegate
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        var position: UIBarPosition = UIBarPosition.Top

        switch tabbarPosition {
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
        var index: Int = indexForViewController(viewController)
        
        if index == 0 {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = indexForViewController(viewController)
        
        if index == pageCount - 1 {
            return nil
        }
        
        index++
        
        return viewControllerAtIndex(index)
    }
    
    // MARK: - PageViewController Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (finished && completed) {
            let vc: UIViewController = pager.viewControllers[0] as! UIViewController
            let index: Int = indexForViewController(vc)
            
            selectTabAtIndex(index)
        }
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let shouldScroll = pageViewScrollDelegate?.scrollViewShouldScrollToTop?(scrollView) {
            return shouldScroll
        }
        
        return false
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageViewScrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pageViewScrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        pageViewScrollDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        pageViewScrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        pageViewScrollDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if let view: UIView = pageViewScrollDelegate?.viewForZoomingInScrollView?(scrollView) {
            return view
        }
        
        return nil
    }
}

// MARK: - RGTabView
private class RGTabView: UIView {
    enum RGTabOrientation {
        case Horizontal
        case VerticalLeft
        case VerticalRight
    }
    
    // variables
    var selected: Bool = false {
        didSet {
            if subviews[0] is RGTabBarItem {
                (subviews[0] as! RGTabBarItem).selected = selected
            } else {
                if style == .InactiveFaded {
                    if selected {
                        alpha = 1.0
                    } else {
                        alpha = 0.566
                    }
                }
                
                setNeedsDisplay()
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
        
        initSelf()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    func initSelf() {
        backgroundColor = UIColor.clearColor()
        
        if style == .InactiveFaded {
            alpha = 0.566
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if selected {
            if !(subviews[0] is RGTabBarItem) {
                var bezierPath: UIBezierPath = UIBezierPath()
                
                switch orientation {
                case .Horizontal:
                    bezierPath.moveToPoint(CGPointMake(0.0, CGRectGetHeight(rect) - indicatorHW / 2.0))
                    bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - indicatorHW / 2.0))
                    bezierPath.lineWidth = indicatorHW
                case .VerticalLeft:
                    bezierPath.moveToPoint(CGPointMake(indicatorHW / 2.0, 0.0))
                    bezierPath.addLineToPoint(CGPointMake(indicatorHW / 2.0, CGRectGetHeight(rect)))
                    bezierPath.lineWidth = indicatorHW
                case .VerticalRight:
                    bezierPath.moveToPoint(CGPointMake(CGRectGetWidth(rect) - (indicatorHW / 2.0), 0.0))
                    bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(rect) - (indicatorHW / 2.0), CGRectGetHeight(rect)))
                    bezierPath.lineWidth = indicatorHW
                }
                
                indicatorColor.setStroke()
                
                bezierPath.stroke()
            }
        }
    }
}

// MARK: - RGTabBarItem
private class RGTabBarItem: UIView {
    var selected: Bool = false {
        didSet {
            setSelectedState()
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
            normalColor = color
        }
        
        initSelf()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    func initSelf() {
        backgroundColor = UIColor.clearColor()
        
        if let img = image {
            imageView = UIImageView(image: img)
            
            addSubview(imageView!)
            
            imageView!.tintColor = normalColor
            imageView!.center.x = center.x
            imageView!.center.y = center.y - 5.0
        }
        
        if let txt = text {
            textLabel = UILabel()
            
            textLabel!.numberOfLines = 1
            textLabel!.text = txt
            textLabel!.textAlignment = NSTextAlignment.Center
            textLabel!.textColor = normalColor
            textLabel!.font = UIFont.systemFontOfSize(10.0)
            
            textLabel!.sizeToFit()
            
            textLabel!.frame = CGRectMake(0.0, frame.size.height - textLabel!.frame.size.height - 3.0, frame.size.width, textLabel!.frame.size.height)
            
            addSubview(textLabel!)
        }
    }
    
    func setSelectedState() {
        if selected {
            textLabel?.textColor = tintColor
            imageView?.tintColor = tintColor
        } else {
            textLabel?.textColor = normalColor
            imageView?.tintColor = normalColor
        }
    }
}

// MARK: - UINavigationBar hide Hairline
extension UINavigationBar {
    func hideHairline() {
        if let hairlineView: UIImageView = findHairlineImageView(containedIn: self) {
            hairlineView.hidden = true
        }
    }
    
    func showHairline() {
        if let hairlineView: UIImageView = findHairlineImageView(containedIn: self) {
            hairlineView.hidden = false
        }
    }
    
    func findHairlineImageView(containedIn view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView: UIImageView = findHairlineImageView(containedIn: subview as! UIView) {
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
    optional func willChangePageToIndex(index: Int, fromIndex from: Int)
    
    /// Delegate objects can implement this method if want to be informed when a page changed.
    ///
    /// :param: index the index of the active page
    optional func didChangePageToIndex(index: Int)
    
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
}
