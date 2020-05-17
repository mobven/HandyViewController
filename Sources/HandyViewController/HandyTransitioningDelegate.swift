//
//  Transitioning.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

public final class HandyTransitioningDelegate: NSObject {
    
    internal weak var scrollViewContentSizeDelegate: HandyScrollViewContentSizeDelegate?
    internal var contentMode: ContentMode = .contentSize
    internal var scrollView: UIScrollView?
    internal var stackView: UIStackView?
    
    /// Initializes transitioing delegate.
    /// - parameter presented: View controller presenting HandyViewController.
    /// - parameter presenting: View controller being presented.
    /// - parameter contentMode: Content mode of HandyViewController.
    public init(from presented: UIViewController, to presenting: UIViewController,
                contentMode: ContentMode = .contentSize) {
        super.init()
        self.contentMode = contentMode
    }
    
    internal func registerHandyScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        if let scrollViewContentSizeDelegate = scrollViewContentSizeDelegate {
            scrollViewContentSizeDelegate.registerHandyScrollView(scrollView)
        }
    }
    
    internal func registerHandyStackView(_ stackView: UIStackView) {
        self.stackView = stackView
        if let scrollViewContentSizeDelegate = scrollViewContentSizeDelegate {
            scrollViewContentSizeDelegate.registerHandyStackView(stackView)
        }
    }
    
}

extension HandyTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {

        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? source.view.safeAreaInsets
        } else {
            safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        let controller = HandyPresentationController(presentedViewController: presented,
                                                     presenting: presenting,
                                                     safeAreaInsets: safeAreaInsets,
                                                     contentMode: contentMode)
        scrollViewContentSizeDelegate = controller
        if let scrollView = scrollView {
            scrollViewContentSizeDelegate?.registerHandyScrollView(scrollView)
        }
        if let stackView = stackView {
            scrollViewContentSizeDelegate?.registerHandyStackView(stackView)
        }
        return controller
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}
