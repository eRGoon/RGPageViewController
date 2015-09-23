//
//  UIHelper.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 10.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.

import Foundation
import UIKit

struct ScreenSize {
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
    static let maxScreenLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let minScreenLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxScreenLength < 568.0
    static let iPhone5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxScreenLength == 568.0
    static let iPhone6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxScreenLength == 667.0
    static let iPhone6Plus = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxScreenLength == 736.0
    static let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.maxScreenLength == 1024.0
}

struct DeviceOrientation {
    static var isPortrait: Bool {
        get {
            return UIApplication.sharedApplication().statusBarOrientation.isPortrait
        }
    }
    static var isLandscape: Bool {
        get {
            return UIApplication.sharedApplication().statusBarOrientation.isLandscape
        }
    }
    
    static func orientationForSize(size: CGSize) -> UIInterfaceOrientation {
        if size.width > size.height {
            return UIInterfaceOrientation.LandscapeLeft
        } else {
            return UIInterfaceOrientation.Portrait
        }
    }
}

struct SystemVersion {
    static func equal(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    static func greaterThan(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    static func greaterThanOrEqual(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    static func lessThan(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    static func lessThanOrEqual(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
}