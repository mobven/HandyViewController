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
    public var handyScrollViewDelegate: HandyScrollViewDelegate? {
        return (transitioningDelegate as? HandyTransitioningDelegate)?.scrollViewDelegate
    }
    
    /// Registers specified scroll view to watch its content size changes.
    /// - parameter scrollView: `UIScrollView` to be registered for content size changes.
    public func registerHandyScrollView(_ scrollView: UIScrollView) {
        (transitioningDelegate as? HandyTransitioningDelegate)?.registerHandyScrollView(scrollView)
    }
    
}
