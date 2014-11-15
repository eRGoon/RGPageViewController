RGPageViewController
===
RGPageViewController is a custom UIPageViewController written in Swift. It is inspired by [ICViewPager](https://github.com/iltercengiz/ICViewPager "ICViewPager") by Ilter Cengiz but with some modifications. It combines an Android-like ViewPager with the blur effect introduced in iOS7. It is fully customizable and can also be used as a replacement for UITabBar.

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

```swift
class MainViewController: RGPageViewController, RGPageViewControllerDataSource, RGPageViewControllerDelegate {
    var tabTitles: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        tabTitles = dateFormatter.monthSymbols

        self.datasource = self
        self.delegate = self
    }
}
```

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
**Description:**&nbsp;&nbsp;Delegate objects can implement this method if they want to be informed when a page  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;changed.  
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
**Description:**&nbsp;&nbsp;Delegate objects can implement this method to set a custom height for the  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tab indicator.  
**Returns:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the height of the tab indicator.  

```swift
optional func widthForTabAtIndex(index: Int) -> CGFloat
```
**Description:**&nbsp;&nbsp;Delegate objects can implement this method if tabs use dynamic width  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or to overwrite the default width for tabs.  
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

Examples
---
### Basic Configuration

```swift
// MARK: - RGPageViewController Data Source
func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int {
    return self.tabTitles.count
}
    
func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView {
    let title: String = self.tabTitles.objectAtIndex(index) as String
    let label: UILabel = UILabel()
    
    label.text = title
    
    label.sizeToFit()
        
    return label
}
    
func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController? {
    // Create a new view controller and pass suitable data.
    let dataViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DataViewController") as DataViewController
        
    dataViewController.dataObject = self.tabTitles[index]
        
    return dataViewController
}
```
#### UITabBar replacement

If you need something similar to a `UITabBar` but with the features of a `UIPageViewController`, change your `tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int)` and implement `heightForTabbar()` as well as `positionForTabbar(bar: UIBarPositioning)`.

```swift
// MARK: - RGPageViewController Delegate
func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView {
    let title: String = self.tabTitles.objectAtIndex(index) as String
    // create a RGTabBarItem and pass a title, an image and a color
    // the color will be used for tinting image and text
    let tabView: RGTabBarItem = RGTabBarItem(frame: CGRectMake(0.0, 0.0, self.view.bounds.width / 6.0, 49.0), text: title, image: UIImage(named: "Grid"), color: nil)
    
    // if you want to adjust the color for selected state of the item, adjust the tintColor
    tabView.tintColor = UIColor.redColor()
        
    return tabView
}

func heightForTabbar() -> CGFloat {
    // default height of UITabBar is 49px
    return 49.0
}

func positionForTabbar(bar: UIBarPositioning) -> UIBarPosition {
    // attach the Tabbar to the bottom of the view
    return UIBarPosition.Bottom
}
```

License
---
The MIT License (MIT)

Copyright (c) 2014 Ronny Gerasch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

