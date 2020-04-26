//
//  HandyScrollViewDelegate.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

/// `UIScrollViewDelegate` actions listened by `HandScrollViewController`.
public protocol HandyScrollViewDelegate: class {
    /// Equivalent to `UIScrollViewDelegate.scrollViewDidScroll(:)` function.
    /// - parameter scrollView: Any `UIScrollView` child class, eg: `UITableView`
    func handyScrollViewDidScroll(_ scrollView: UIScrollView)
    /// Equivalent to `UIScrollViewDelegate.scrollViewWillEndDragging(:)` function.
    /// - parameter scrollView: Any `UIScrollView` child class, eg: `UITableView`
    /// - parameter velocity: Velocity of dragging on scroll view.
    func handyScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint)
}

/// Internal delegate function for registering to `UIScrollView` content size changes.
protocol HandyScrollViewContentSizeDelegate: class {
    /// Registers for content size changes within specified scroll view.
    /// - parameter scrollView: `UIScrollView` to be registered.
    func registerHandyScrollView(_ scrollView: UIScrollView)
}
