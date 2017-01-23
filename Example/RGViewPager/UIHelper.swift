//
//  UIHelper.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 10.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.

import Foundation
import UIKit

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let maxScreenLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let minScreenLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxScreenLength < 568.0
    static let iPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxScreenLength == 568.0
    static let iPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxScreenLength == 667.0
    static let iPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxScreenLength == 736.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxScreenLength == 1024.0
}

struct DeviceOrientation {
    static var isPortrait: Bool {
        get {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
    static var isLandscape: Bool {
        get {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    static func orientationForSize(_ size: CGSize) -> UIInterfaceOrientation {
        if size.width > size.height {
            return UIInterfaceOrientation.landscapeLeft
        } else {
            return UIInterfaceOrientation.portrait
        }
    }
}

struct SystemVersion {
    static func equal(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    static func greaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    static func greaterThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    static func lessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    static func lessThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
}
