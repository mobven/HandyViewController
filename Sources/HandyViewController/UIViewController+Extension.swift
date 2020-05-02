//
//  UIViewController+Extension.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Delegate for `UIScrollView` events withing `HandyViewController`.
    @available(*, unavailable, message: "Please use UIViewController.handyScrollView... equivalents")
    public var handyScrollViewDelegate: HandyScrollViewDelegate? {
        return nil
    }
    
    /// Registers specified scroll view to watch its content size changes.
    /// - parameter scrollView: `UIScrollView` to be registered for content size changes.
    public func registerHandyScrollView(_ scrollView: UIScrollView) {
        (transitioningDelegate as? HandyTransitioningDelegate)?.registerHandyScrollView(scrollView)
    }
    
    /// Call from `UIScrollViewDelegate.scrollViewDidScroll(:)` function to achieve swipe-to-dismiss.
    /// - parameter scrollView: Any `UIScrollView` child class, eg: `UITableView`
    public func handyScrollViewDidScroll(_ scrollView: UIScrollView) {
        (presentationController as? HandyPresentationController)?.handyScrollViewDidScroll(scrollView)
    }
    /// Call from `UIScrollViewDelegate.scrollViewWillEndDragging(:)` function to achieve swipe-to-dismiss.
    /// - parameter scrollView: Any `UIScrollView` child class, eg: `UITableView`
    /// - parameter velocity: Velocity of dragging on scroll view.
    public func handyScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        (presentationController as? HandyPresentationController)?.handyScrollViewWillEndDragging(scrollView,
                                                                                                 withVelocity: velocity)
    }
    
}
