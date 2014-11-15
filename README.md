RGPageViewController
===
RGPageViewController is a custom UIPageViewController written in Swift. It is inspired by [ICViewPager](https://github.com/iltercengiz/ICViewPager "ICViewPager") by Ilter Cengiz but adds some extra features. It combines an Android-like ViewPager with the blur effect introduced in iOS7. It is fully customizable and can also be used as a replacement for UITabBar.

Screenshots
---

<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10">
<img src="http://ergoon.github.io/RGPageViewController/images/default.png" width="210" title="Default settings">
<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="20">
<img src="http://ergoon.github.io/RGPageViewController/images/uitabbar.png" width="210" title="UITabBar mode">
<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="20">
<img src="http://ergoon.github.io/RGPageViewController/images/colored.png" width="210" title="Custom colors">

Installation
---
Simply copy `RGPageViewController.swift` to your project.

Usage
---
Subclass `RGPageViewController` and implement it's `datasource` and `delegate` methods.

### RGPageViewControllerDataSource
```swift
func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int
```
**Description:**&nbsp;&nbsp;Asks the datasource about the number of pages.  
**Parameters:**&nbsp;&nbsp;`pageViewController`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the RGPageViewController instance that's subject to.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the total number of pages.  

```swift
func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView
```
**Description:**&nbsp;&nbsp;Asks the datasource to give a view to display as a tab item.  
**Parameters:**&nbsp;&nbsp;`pageViewController`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the RGPageViewController instance that's subject to.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`index`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the index of the tab whose view is asked.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a UIView instance that will be shown as tab at the given index.  

```swift
func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController?
```
**Description:**&nbsp;&nbsp;Asks the datasource to give a ViewController to display as a page.  
**Parameters:**&nbsp;&nbsp;`pageViewController`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the RGPageViewController instance that's subject to.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`index`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the index of the content whose view is asked.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a UIViewController instance whose view will be shown as content at the given index.  

### RGPageViewControllerDelegate
```swift
optional func didChangePageToIndex(index: Int)
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method if they want to be informed when a page changed.  
**Parameters:**&nbsp;&nbsp;`index`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the index of the current page.  

```swift
optional func heightForTabbar() -> CGFloat
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to set a custom height for the tabbar.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the height of the tabbar.  

```swift
optional func heightForIndicator() -> CGFloat
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to set a custom height for the tab indicator.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the height of the tab indicator.  

```swift
optional func widthForTabAtIndex(index: Int) -> CGFloat
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method if tabs use dynamic width or to overwrite the default width for tabs.  
**Parameters:**&nbsp;&nbsp;`index`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the index of the tab.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the width for the tab at the given index.  

```swift
optional func positionForTabbar(bar: UIBarPositioning) -> UIBarPosition
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to specify the position of the tabbar.  
**Parameters:**&nbsp;&nbsp;`bar`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the tabbar.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the position for the tabbar.  

```swift
optional func colorForTabIndicator() -> UIColor
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to specify the color of the tab indicator.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the color for the tab indicator.  

```swift
optional func tintColorForTabBar() -> UIColor?
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to specify a tint color for the tabbar.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thethe tint color for the tabbar.  
