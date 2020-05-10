//
//  UIViewController+Extension.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Registers specified scroll view to watch its content size changes.
    /// - parameter scrollView: `UIScrollView` to be registered for content size changes.
    public func registerHandyScrollView(_ scrollView: UIScrollView) {
        (transitioningDelegate as? HandyTransitioningDelegate)?.registerHandyScrollView(scrollView)
    }
    
    /// Manipulates stack view by adding empty arranged subview in the end,
    /// for those with types `UIStackView.Alignment.Distribution.fill` and `UIStackView.Alignment.Alignment.fill`
    /// - parameter stackView: `UIStackView` to be manipulated for height.
    public func registerHandyStackView(_ stackView: UIStackView) {
        (transitioningDelegate as? HandyTransitioningDelegate)?.registerHandyStackView(stackView)
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
