//
//  RGPageViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 08.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

// MARK: - RGTabbarStyle
enum RGTabbarStyle {
  case solid
  case blurred
}
// MARK: - RGTabStyle
enum RGTabStyle {
  case none
  case inactiveFaded
}
// MARK: - RGTabbarPosition
enum RGTabbarPosition {
  case top
  case bottom
  case left
  case right
}

// MARK: - RGPageViewController
public class RGPageViewController: UIViewController {
  // MARK: - Protocols
  public weak var datasource: RGPageViewControllerDataSource?
  public weak var delegate: RGPageViewControllerDelegate?
  internal var pageViewScrollDelegate: UIScrollViewDelegate?
  
  // MARK: - Variables
  private var needsSetup: Bool = true
  private var animatingToTab: Bool = false
  
  // MARK: - Pager
  var pageCount: Int = 0
  var currentPageIndex: Int = 0
  var pager: UIPageViewController!
  var pagerOrientation: UIPageViewControllerNavigationOrientation {
    get {
      return .horizontal
    }
  }
  var pagerScrollView: UIScrollView?
  var pageViewControllers: Array<UIViewController?> = Array<UIViewController>()
  
  // MARK: - Tabs
  var currentTabIndex: Int = 0
  var tabWidth: CGFloat = UIScreen.main.bounds.size.width / 3.0
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
      return UIColor.lightGray
    }
  }
  var tabMargin: CGFloat {
    get {
      return 0.0
    }
  }
  var tabStyle: RGTabStyle {
    get {
      return .none
    }
  }
  // MARK: - Tabbar
  var tabbarHidden: Bool {
    get {
      return false
    }
  }
  var tabbarStyle: RGTabbarStyle {
    get {
      return .blurred
    }
  }
  var tabbarPosition: RGTabbarPosition {
    get {
      return .top
    }
  }
  var tabbarTop: CGFloat {
    get {
      return 20
    }
  }
  var tabbar: UIView!
  var barTintColor: UIColor? {
    get {
      return nil
    }
  }
  var tabScrollView: UICollectionView!
  
  // MARK: - Constructors
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  // MARK: - ViewController life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    initPager()
    initTabBar()
    initTabScrollView()
    
    layoutSubviews()
    
    view.addSubview(pager.view)
    view.addSubview(tabbar)
  }
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if needsSetup {
      setupSelf()
    }
  }
  
  // MARK: - Functions
  private func initPager() {
    pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: pagerOrientation, options: nil)
    
    addChildViewController(pager)
    
    pagerScrollView = pager.view.subviews.first as? UIScrollView
    pageViewScrollDelegate = pagerScrollView?.delegate
    
    pagerScrollView?.scrollsToTop = false
    pagerScrollView?.delegate = self
  }
  
  private func initTabBar() {
    switch tabbarStyle {
    case .blurred:
      tabbar = UIToolbar()
      
      if let tabbar = self.tabbar as? UIToolbar {
        tabbar.barTintColor = barTintColor
        tabbar.isTranslucent = true
        tabbar.delegate = self
      }
    case .solid:
      tabbar = UIView()
      
      tabbar.backgroundColor = barTintColor
    }
    
    tabbar.isHidden = tabbarHidden
  }
  
  private func initTabScrollView() {
    tabScrollView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    tabScrollView.backgroundColor = UIColor.clear
    tabScrollView.scrollsToTop = false
    tabScrollView.isOpaque = false
    tabScrollView.showsHorizontalScrollIndicator = false
    tabScrollView.showsVerticalScrollIndicator = false
    tabScrollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "rgTabCell")
    
    tabbar.addSubview(tabScrollView)
  }
  
  private func layoutSubviews() {
    switch tabbarPosition {
    case .top:
      layoutTabbarTop()
    case .bottom:
      layoutTabbarBottom()
    case .left:
      layoutTabbarLeft()
    case .right:
      layoutTabbarRight()
    }
  }
  
  private func layoutTabbarTop() {
    tabbar.autoresizingMask = .flexibleWidth
    tabScrollView.autoresizingMask = .flexibleWidth
    pager.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    (tabScrollView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
    
    var barTop: CGFloat = tabbarTop
    
    // remove hairline image in navigation bar if attached to top
    if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
      barTop += 44
      
      navigationController.navigationBar.hideHairline()
    }
    
    tabbar.frame = tabbarHidden ? .zero : CGRect(
      x: 0,
      y: barTop,
      width: view.bounds.size.width,
      height: tabbarHeight
    )
    
    tabScrollView.frame = CGRect(
      x: 0,
      y: 0,
      width: tabbar.frame.size.width,
      height: tabbar.frame.size.height
    )
    
    pager.view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.bounds.size.width,
      height: view.bounds.size.height
    )
  }
  
  private func layoutTabbarBottom() {
    tabbar.autoresizingMask = .flexibleWidth
    tabScrollView.autoresizingMask = .flexibleWidth
    pager.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    (tabScrollView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
    
    tabbar.frame = tabbarHidden ? .zero : CGRect(
      x: 0,
      y: view.bounds.size.height - tabbarHeight,
      width: view.bounds.size.width,
      height: tabbarHeight
    )
    
    tabScrollView.frame = CGRect(
      x: 0,
      y: 0,
      width: tabbar.frame.size.width,
      height: tabbar.frame.size.height
    )
    
    pager.view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.bounds.size.width,
      height: view.bounds.size.height
    )
  }
  
  private func layoutTabbarLeft() {
    tabbar.autoresizingMask = .flexibleHeight
    tabScrollView.autoresizingMask = .flexibleHeight
    pager.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    (tabScrollView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .vertical
    
    var barTop: CGFloat = 0
    
    if tabbarStyle != .solid {
      barTop = tabbarTop
      
      if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
        barTop += 44
      }
    }
    
    tabbar.frame = tabbarHidden ? .zero : CGRect(
      x: 0,
      y: barTop,
      width: tabbarWidth,
      height: view.bounds.size.height - barTop
    )
    
    tabScrollView.frame = CGRect(
      x: 0,
      y: 0,
      width: tabbar.frame.size.width,
      height: tabbar.frame.size.height
    )
    
    if tabbarStyle == .solid {
      var scrollTop: CGFloat = tabbarTop
      
      if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
        scrollTop += 44
      }
      
      var edgeInsets: UIEdgeInsets = tabScrollView.contentInset
      
      edgeInsets.top = scrollTop
      edgeInsets.bottom = 0
      
      tabScrollView.contentInset = edgeInsets
      tabScrollView.scrollIndicatorInsets = edgeInsets
    }
    
    pager.view.frame = CGRect(
      x: tabbar.frame.size.width,
      y: 0,
      width: view.bounds.size.width - tabbar.frame.size.width,
      height: view.bounds.size.height
    )
  }
  
  private func layoutTabbarRight() {
    tabbar.autoresizingMask = .flexibleHeight
    tabScrollView.autoresizingMask = .flexibleHeight
    pager.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    (tabScrollView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .vertical
    
    var barTop: CGFloat = 0
    
    if tabbarStyle != .solid {
      barTop = tabbarTop
      
      if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
        barTop += 44
      }
    }
    
    tabbar.frame = tabbarHidden ? .zero : CGRect(
      x: view.bounds.size.width - tabbarWidth,
      y: barTop,
      width: tabbarWidth,
      height: view.bounds.size.height - barTop
    )
    
    tabScrollView.frame = CGRect(
      x: 0,
      y: 0,
      width: tabbar.frame.size.width,
      height: tabbar.frame.size.height
    )
    
    if tabbarStyle == .solid {
      var scrollTop: CGFloat = tabbarTop
      
      if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
        scrollTop += 44
      }
      
      var edgeInsets: UIEdgeInsets = tabScrollView.contentInset
      
      edgeInsets.top = scrollTop
      edgeInsets.bottom = 0
      
      tabScrollView.contentInset = edgeInsets
      tabScrollView.scrollIndicatorInsets = edgeInsets
    }
    
    pager.view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.bounds.size.width - tabbar.frame.size.width,
      height: view.bounds.size.height
    )
  }
  
  private func setupSelf() {
    pageCount = datasource?.numberOfPagesForViewController(self) ?? 0
    
    pageViewControllers.removeAll()
    pageViewControllers = Array<UIViewController?>(repeating: nil, count: pageCount)
    
    pager.dataSource = self
    pager.delegate = self
    
    tabScrollView.dataSource = self
    tabScrollView.delegate = self
    
    selectTabAtIndex(currentTabIndex, updatePage: true)
    
    needsSetup = false
  }
  
  internal func tabViewAtIndex(_ index: Int) -> RGTabView? {
    if let tabViewContent: UIView = datasource?.tabViewForPageAtIndex(self, index: index) {
      var tabView: RGTabView
      var frame: CGRect = .zero
      var orientation: RGTabOrientation = .horizontal
      
      switch tabbarPosition {
      case .top, .bottom:
        if let theWidth: CGFloat = delegate?.widthForTabAtIndex?(index) {
          frame = CGRect(
            x: 0,
            y: 0,
            width: theWidth,
            height: tabbarHeight
          )
        } else {
          frame = CGRect(
            x: 0,
            y: 0,
            width: tabWidth,
            height: tabbarHeight
          )
        }
      case .left:
        if let theHeight: CGFloat = delegate?.heightForTabAtIndex?(index) {
          frame = CGRect(
            x: 0,
            y: 0,
            width: tabbarWidth,
            height: theHeight
          )
        } else {
          frame = CGRect(
            x: 0,
            y: 0,
            width: tabbarWidth,
            height: tabbarWidth
          )
        }
        
        orientation = .verticalLeft
      case .right:
        if let theHeight: CGFloat = delegate?.heightForTabAtIndex?(index) {
          frame = CGRect(
            x: 0,
            y: 0,
            width:
            tabbarWidth,
            height: theHeight
          )
        } else {
          frame = CGRect(
            x: 0,
            y: 0,
            width: tabbarWidth,
            height: tabbarWidth
          )
        }
        
        orientation = .verticalRight
      }
      
      tabView = RGTabView(
        frame: frame,
        indicatorColor: tabIndicatorColor,
        indicatorHW: tabIndicatorWidthOrHeight,
        style: tabStyle,
        orientation: orientation
      )
      
      tabView.clipsToBounds = true
      tabView.addSubview(tabViewContent)
      
      tabViewContent.center = tabView.center
      
      return tabView
    }
    
    return nil
  }
  
  internal func selectTabAtIndex(_ index: Int, updatePage: Bool) {
    if index >= pageCount {
      return
    }
    
    animatingToTab = true
    
    updateTabIndex(index, animated: true)
    
    if updatePage {
      updatePager(index)
    } else {
      currentPageIndex = index
    }
    
    delegate?.didChangePageToIndex?(index)
  }
  
  private func updateTabIndex(_ index: Int, animated: Bool) {
    deselectCurrentTab()
    selectTab(at: index, animated: animated)
    
    currentTabIndex = index
  }
  
  private func deselectCurrentTab() {
    let indexPath = IndexPath(row: currentTabIndex, section: 0)
    
    if let tabView = tabScrollView.cellForItem(at: indexPath)?.contentView.subviews.first as? RGTabView {
      tabView.selected = false
    }
  }
  
  private func selectTab(at index: Int, animated: Bool) {
    let indexPath = IndexPath(row: index, section: 0)
    let cell = tabScrollView.cellForItem(at: indexPath) ?? collectionView(tabScrollView, cellForItemAt: indexPath)
    var cellFrame = cell.frame
    
    switch tabbarPosition {
    case .top, .bottom:
      cellFrame.origin.x -= (index == 0 ? tabMargin : tabMargin / 2.0)
      cellFrame.size.width += tabMargin
    case .left, .right:
      cellFrame.origin.y -= tabMargin / 2.0
      cellFrame.size.height += tabMargin
    }
    
    let rect = tabScrollView.convert(cellFrame, to: tabScrollView.superview)
    let cellIsVisible = tabScrollView.frame.contains(rect)
    
    if !cellIsVisible {
      var scrollPosition: UICollectionViewScrollPosition = UICollectionViewScrollPosition()
      
      if index > currentTabIndex {
        switch tabbarPosition {
        case .top, .bottom:
          scrollPosition = .right
        case .left, .right:
          scrollPosition = .bottom
        }
      } else {
        switch tabbarPosition {
        case .top, .bottom:
          scrollPosition = .left
        case .left, .right:
          scrollPosition = .top
        }
      }
      
      tabScrollView.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
      tabScrollView.scrollRectToVisible(cellFrame, animated: animated)
    }
    
    if let tabView = cell.contentView.subviews.first as? RGTabView {
      tabView.selected = true
    }
  }
  
  private func updatePager(_ index: Int) {
    guard let viewController = viewControllerAtIndex(index) else {
      return
    }
    
    if index == currentPageIndex {
      pager.setViewControllers([viewController], direction: .forward, animated: false, completion: { [unowned self] _ -> Void in
        self.animatingToTab = false
      })
    } else if !(index + 1 == currentPageIndex || index - 1 == currentPageIndex) {
      pager.setViewControllers([viewController], direction: index < currentPageIndex ? .reverse : .forward, animated: true, completion: { [unowned self] (finished) -> Void in
        self.animatingToTab = false
        
        DispatchQueue.main.async { [unowned self] in
          self.pager.setViewControllers([viewController], direction: index < self.currentPageIndex ? .reverse : .forward, animated: false, completion: nil)
        }
      })
    } else {
      pager.setViewControllers([viewController], direction: index < currentPageIndex ? .reverse : .forward, animated: true, completion: { [weak self] (Bool) -> Void in
        self?.animatingToTab = false
      })
    }
    
    currentPageIndex = index
  }
  
  internal func indexForViewController(_ viewController: UIViewController) -> Int? {
    return pageViewControllers.index(where: { $0 == viewController })
  }
  
  func reloadData() {
    pageCount = datasource?.numberOfPagesForViewController(self) ?? 0
    
    pageViewControllers.removeAll()
    pageViewControllers = Array<UIViewController?>(repeating: nil, count: pageCount)
    
    tabScrollView.reloadData()
    
    selectTabAtIndex(currentTabIndex, updatePage: true)
  }
}
